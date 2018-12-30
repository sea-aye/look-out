module LookOut
  class Cast
    include ::HTTParty
    extend Client

    def self.create(options)
      client.post('/casts', body: options.to_json)
    end
  end
end
