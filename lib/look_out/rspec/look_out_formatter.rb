module LookOut
  module RSpec
    class LookOutFormatter < ::RSpec::Core::Formatters::JsonFormatter
      ::RSpec::Core::Formatters.register self, :close

      def close(_notification)
        output_hash[:examples].each do |example|
          %i(description full_description pending_message).each do |key|
            example.delete(key)
          end
        end

        LookOut::Cast.create(
          api_key: LookOut.config.api_key,
          user: LookOut.config.user,
          data: output_hash,
          repo: LookOut.config.repo,
          sha: sha,
          env: env
        )
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
