require 'typhoeus'
require 'utils/compact'

require 'look_out/version'

module LookOut
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :user, :red_cove_api_key, :first_mate_api_key
  end
end
