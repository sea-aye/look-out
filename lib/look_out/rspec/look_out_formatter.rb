require 'securerandom'

module LookOut
  module RSpec
    class LookOutFormatter < ::RSpec::Core::Formatters::JsonFormatter
      ::RSpec::Core::Formatters.register self, :close

      def close(_notification)
        output_hash[:examples].each do |example|
          %i(full_description pending_message).each do |key|
            example.delete(key)
          end
        end

        hydra = Typhoeus::Hydra.hydra

        first_mate_request = Typhoeus::Request.new(
          "#{first_mate_host}/casts",
          method: :post,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            api_key: LookOut.config.api_key,
            data: output_hash,
            cast: {
              user: LookOut.config.user,
              sha: sha,
              env: env,
              integrated: integrated
            }
          }.to_json
        )

        hydra.queue(first_mate_request)

        if defined?(SimpleCov)
          SimpleCov.result.format!
          data = {
            'coverage' => SimpleCov.result.to_hash['RSpec']['coverage'].
                 transform_keys { |key| key.sub(/^#{SimpleCov.root}/, '') }
          }
          red_request = Typhoeus::Request.new(
            "#{red_cove_host}/sails",
            method: :post,
            body: {
              api_key: LookOut.config.api_key,
              data: data.to_json,
              sail: {
                uid: uid,
                user: LookOut.config.user,
                sha: sha,
                env: env,
                integrated: integrated
              }
            }
          )
          hydra.queue(red_request)
        end

        hydra.run

        if ENV['LOOK_OUT_VERBOSE']
          pp first_mate_request
          pp first_mate_request&.response
          pp red_request
          pp red_request&.response
        end
      end

      private

      def uid
        ENV['TRAVIS_BUILD_ID'] || ENV['HEROKU_TEST_RUN_ID'] || ENV['CIRCLE_WORKFLOW_ID'] || SecureRandom.hex
      end

      def sha
        ENV['GIT_COMMIT_SHA'] || ENV['HEROKU_TEST_RUN_COMMIT_VERSION'] || ENV['CIRCLE_SHA1'] ||
          `git log -1 --format=%H`.chomp
      end

      def red_cove_host
        ENV['RED_COVE_HOST'] || 'https://sea-aye.com/api/red-cove'
      end

      def first_mate_host
        ENV['FIRST_MATE_HOST'] || 'https://sea-aye.com/api/first-mate'
      end

      def integrated
        if ENV['LOOK_OUT_INTEGRATED']
          true
        else
          false
        end
      end
      def env
        if ENV['JENKINS'] || ENV['CI']
          :integration
        else
          :development
        end
      end
    end
  end
end
