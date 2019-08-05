module XIVAPI
  # Custom errors
  module Errors
    # Standard request error
    class RequestError < StandardError
      def initialize(response)
        if response.headers[:content_type] =~ /json/
          message = JSON.parse(response)['Message']
        else
          message = 'Error contacting the API.'
        end

        super(message)
      end
    end

    # Rate limited
    class RateLimitError < StandardError
      def initialize
        super('Too many requests.')
      end
    end
  end
end
