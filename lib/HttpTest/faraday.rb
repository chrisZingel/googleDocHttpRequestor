require 'faraday'
require 'faraday-cookie_jar'
module HttpTest
  class Faraday

    attr_accessor :conn

    def initialize
      @conn = ::Faraday.new(:url => Settings.get.root_url) do |faraday|
        faraday.use :cookie_jar
        faraday.adapter  ::Faraday.default_adapter
      end
    end

    def http_request(http_request, path, body)
     response = conn.send(http_request) do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json' unless %"get delete".include?(http_request)
        req.body = body unless %"get delete".include?(http_request)
      end
      return {status: response.status, body: response.body}
    end

  end
end
