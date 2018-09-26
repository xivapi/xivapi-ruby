module XIVAPI
  class RequestError < StandardError
    def initialize(response)
      if response.headers[:content_type] == 'application/problem+json'
        message = JSON.parse(response)['Message']
      else
        message = 'Error contacting the API.'
      end

      super(message)
    end
  end

  class RateLimitError < StandardError
    def initialize
      super('Too many requests.')
    end
  end

  class ContentNotAvailable < StandardError
    def initialize
      super('Content is not currently available on XIVAPI.')
    end
  end

  class ContentNotFound < StandardError
    def initialize
      super('Content does not exist on the Lodestone.')
    end
  end

  class ContentBlacklisted < StandardError
    def initialize
      super('Content has been blacklisted.')
    end
  end

  class ContentPrivate < StandardError
    def initialize
      super('Content is private.')
    end
  end
end
