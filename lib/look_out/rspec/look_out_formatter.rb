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

        STDERR.puts "\n[look-out] Cast rejected, check api key.\n" if response.code == 401
      end

      private

      def sha
        ENV['GIT_COMMIT_SHA'] || `git log -1 --format=%H`.chomp
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
