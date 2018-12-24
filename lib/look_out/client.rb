module LookOut
  # Encapsulates the configuration of each client before JIT before requests
  # are made. This allows us to use our configuration which won't have been
  # available until runtime, not load time.
  module Client
    def client
      base_uri 'https://api.sea-aye.com/v1'
      headers('Content-Type' => 'application/json')
      self
    end
  end
end
