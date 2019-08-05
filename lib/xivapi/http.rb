module XIVAPI
  # Makes HTTP request to XIVAPI
  module HTTP
    # Base URL for XIVAPI
    API_BASE = 'https://xivapi.com'.freeze

    # Base URL for the staging environment of XIVAPI
    STAGING_API_BASE = 'https://staging.xivapi.com'.freeze

    # Makes a request to XIVAPI
    # @param client [XIVAPI::Client] The client making the request
    # @param endpoint [String, Symbol] The endpoint to request
    # @param params [Hash] Request parameters
    # @param payload [Hash] Request body
    # @return the results of the request
    def request(client, endpoint, params = {}, payload = nil)
      url = request_url(client, endpoint)
      query_params = params.merge(client.default_params)
        .reject { |_, v| v.nil? || v.size == 0 }

      begin
        if payload
          response = RestClient::Request.execute(method: :get, url: url, headers: { params: query_params },
                                                 payload: payload.to_json)
        else
          response = RestClient.get(url, params: query_params)
        end

        body = JSON.parse(response.body)
        objectify(body)
      rescue RestClient::ExceptionWithResponse => e
        if e.http_code == 429
          raise XIVAPI::RateLimitError.new
        else
          raise XIVAPI::RequestError.new(e.response)
        end
      rescue RestClient::Exception => e
        raise e
      end
    end

    private
    def request_url(client, endpoint)
      "#{client.staging ? STAGING_API_BASE : API_BASE}/#{endpoint}"
    end

    def objectify(response)
      case response
      when Hash
        result = {}

        response.each do |key, value|
          case value
          when Hash, Array
            new_value = objectify(value)
          else
            new_value = value
          end

          result[underscore(key)] = new_value
        end

        OpenStruct.new(result)
      when Array
        response.map { |data| objectify(data) }
      else
        response
      end
    end

    def underscore(key)
      key.gsub('PvPTeam', 'PvpTeam').gsub(/([a-z\d])([A-Z])/,'\1_\2').gsub('.', '_').downcase
    end
  end
end
