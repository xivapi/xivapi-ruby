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

    # Content not available
    class ContentNotAvailable < StandardError
      def initialize
        super('Content is not currently available on XIVAPI.')
      end
    end

    # Content not found
    class ContentNotFound < StandardError
      def initialize
        super('Content does not exist on the Lodestone.')
      end
    end

    # Content blacklisted
    class ContentBlacklisted < StandardError
      def initialize
        super('Content has been blacklisted.')
      end
    end

    # Content private
    class ContentPrivate < StandardError
      def initialize
        super('Content is private.')
      end
    end
  end
end
