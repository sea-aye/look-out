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

        response = LookOut::Cast.create(
          api_key: LookOut.config.api_key,
          user: LookOut.config.user,
          data: output_hash,
          repo: LookOut.config.repo,
          sha: sha,
          env: env
        )

        hydra = Typhoeus::Hydra.hydra

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
        hydra.run

        STDERR.puts "\n[look-out] Cast rejected, check api key.\n" if response.code == 401
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
