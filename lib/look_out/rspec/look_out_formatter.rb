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
            "#{first_mate_host}/casts",
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
          data = {
            'coverage' => SimpleCov.result.to_hash['RSpec']['coverage'].
                 transform_keys { |key| key.sub(/^#{SimpleCov.root}/, '') }
          }
          red_request = Typhoeus::Request.new(
            "#{red_cove_host}/v1/sails",
            method: :post,
            body: {
              api_key: LookOut.config.red_cove_api_key,
              data: data.to_json,
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

        if first_mate_request&.response&.code == 401
          STDERR.puts "\n[look-out] Cast rejected, check First Mate API Key.\n"
          STDERR.puts "[look-out] https://www.sea-aye.com/first-mate \n"
        end

        if red_request&.response&.code == 401
          STDERR.puts "\n[look-out] Sail rejected, check Red Cove API Key.\n"
          STDERR.puts "[look-out] https://www.sea-aye.com/red-cove \n"
        end

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
