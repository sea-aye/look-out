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

        if LookOut.config.first_mate_api_key
          first_mate_request = Typhoeus::Request.new(
            'https://first-mate.sea-aye.com/v1/casts',
            method: :post,
            headers: { 'Content-Type' => 'application/json' },
            body: {
              api_key: LookOut.config.first_mate_api_key,
              data: output_hash,
              cast: {
                user: LookOut.config.user,
                sha: sha,
                env: env
              }
            }.to_json
          )

          hydra.queue(first_mate_request)
        end

        if LookOut.config.red_cove_api_key && defined?(SimpleCov)
          SimpleCov.result.format!
          red_request = Typhoeus::Request.new(
            'https://red-cove.sea-aye.com/v1/sails',
            method: :post,
            body: {
              api_key: LookOut.config.red_cove_api_key,
              data: SimpleCov.result.to_hash['RSpec'].to_json,
              sail: {
                uid: uid,
                sha: sha,
                env: env
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
        ENV['TRAVIS_BUILD_ID'] || ENV['HEROKU_TEST_RUN_ID'] || SecureRandom.hex
      end

      def sha
        ENV['GIT_COMMIT_SHA'] || ENV['HEROKU_TEST_RUN_COMMIT_VERSION'] ||
          `git log -1 --format=%H`.chomp
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
