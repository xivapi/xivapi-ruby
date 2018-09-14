module XIVAPI
  module HTTP
    API_BASE = 'https://xivapi.com'.freeze

    def request(client, endpoint, params = {})
      url = request_url(endpoint)
      query_params = params.merge(client.default_params)
        .reject { |_, v| v.nil? || v.size == 0 }

      begin
        response = RestClient.get(url, params: query_params)
        body = JSON.parse(response.body)
        objectify(body)
      rescue RestClient::ExceptionWithResponse => e
        raise XIVAPI::RequestError.new(e.response)
      rescue RestClient::Exception => e
        raise e
      end
    end

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
    def request_url(endpoint)
      "#{API_BASE}/#{endpoint}"
    end

    def objectify(response)
      return response unless response.is_a?(Hash)
      result = {}

      response.each do |key, value|
        if value.is_a?(Hash)
          new_value = objectify(value)
        elsif value.is_a?(Array)
          new_value = value.map { |val| objectify(val) }
        else
          new_value = value
        end

        result[underscore(key)] = new_value
      end

      OpenStruct.new(result)
    end

    def underscore(key)
      key.gsub(/([a-z\d])([A-Z])/,'\1_\2').gsub('.', '_').downcase
    end
  end
end
