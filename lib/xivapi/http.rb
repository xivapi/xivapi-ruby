module XIVAPI
  module HTTP
    API_BASE = 'https://xivapi.com'.freeze

    def request(endpoint)
      url = request_url(endpoint)

      begin
        RestClient.get(url).body
      rescue RestClient::Exception => e
        raise e.response
      end
    end

    private
    def request_url(endpoint)
      "#{API_BASE}/#{endpoint}"
    end
  end
end
