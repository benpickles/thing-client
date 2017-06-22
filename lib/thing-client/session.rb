require 'json'
require 'net/http'
require 'uri'
require 'thing-client/resource'

module ThingClient
  class Session
    HTTPS = 'https'

    def self.root(url)
      new(url).call(url)
    end

    attr_reader :root

    def initialize(root)
      @root = URI.parse(root)
    end

    def call(url)
      uri = URI.parse(url)

      req = Net::HTTP::Get.new(uri)
      req['Accept'] = 'application/json'
      req['Accept-Charset'] = 'utf-8'
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: uri.scheme == HTTPS,
      ) { |http|
        http.request(req)
      }

      data = JSON.parse(res.body)

      Resource.new(data, session: self)
    end
  end
end
