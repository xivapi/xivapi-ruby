module XIVAPI
  module HTTP
    API_BASE = 'https://xivapi.com'.freeze

    def request(endpoint, params = {})
      url = request_url(endpoint)
      query_params = params.reject { |_, v| v.nil? || v.size == 0 }

      begin
        RestClient.get(url, params: query_params).body
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
