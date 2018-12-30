require 'hashie'
require 'httparty'
require 'utils/compact'

require 'look_out/version'
require 'look_out/client'

require 'look_out/cast'

module LookOut
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :api_key, :env, :repo, :user
  end
end
