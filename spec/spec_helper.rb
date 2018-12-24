require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'dotenv'
Dotenv.load('.env.test')

require 'pry'
require 'vcr'
require 'look_out'

LookOut.configure do |config|
  config.api_key = ENV['API_KEY']
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Let's you set default VCR mode with VCR=all for re-recording
  # episodes. :once is VCR default.
  # to record again an API call just set VCR=all
  # spec your_test_file_spec.rb:line number
  record_mode = ENV['VCR'] ? ENV['VCR'].to_sym : :once
  config.default_cassette_options = { record: record_mode }
end
