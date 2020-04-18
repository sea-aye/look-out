require 'typhoeus'

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
    attr_accessor :user, :api_key
  end
end
