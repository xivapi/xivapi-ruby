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
    # @return the results of the request
    def request(client, endpoint, params = {})
      url = request_url(client, endpoint)
      query_params = params.merge(client.default_params)
        .reject { |_, v| v.nil? || v.size == 0 }

      begin
        response = RestClient.get(url, params: query_params)
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

    # Makes a request to XIVAPI for cached data. This is data that must be cached
    # by XIVAPI before it can be served. This method should be used over the standard
    # request in order to properly throw custom errors and enable polling. Polling
    # will continuously call the API until the data is cached and returned.
    #
    # @param client [XIVAPI::Client] The client making the request
    # @param endpoint [String, Symbol] The endpoint to request
    # @param key [String, Symbol] The results key that stores the cached data
    # @param params [Hash] Request parameters
    # @param poll [true, false] Whether or not to poll XIVAPI until data is returned
    # @return the results of the request
    def request_cached(client, endpoint, key, params = {}, poll = false)
      response = request(client, endpoint, params)

      case(response.info[key].state)
      when 0
        raise XIVAPI::ContentNotAvailable
      when 1
        if poll
          sleep(client.poll_rate)
          response = request_cached(client, endpoint, key, params, poll)
        end
      when 3
        raise XIVAPI::ContentNotFound
      when 4
        raise XIVAPI::ContentBlacklisted
      when 5
        raise XIVAPI::ContentPrivate
      end

      response
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
