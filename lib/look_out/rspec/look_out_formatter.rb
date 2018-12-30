module LookOut
  module RSpec
    class LookOutFormatter < ::RSpec::Core::Formatters::JsonFormatter
      ::RSpec::Core::Formatters.register self, :close

      def close(_notification)
        output_hash[:examples].each do |example|
          %i(description full_description line_number pending_message file_path).each do |key|
            example.delete(key)
          end
        end

        LookOut::Cast.create(
          user: LookOut.config.user,
          data: output_hash,
          repo: LookOut.config.repo,
          sha: `git log -1 --format=%H`.chomp,
          env: LookOut.config.env
        )
      end
    end
  end
end
