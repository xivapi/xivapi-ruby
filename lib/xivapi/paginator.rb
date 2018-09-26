module XIVAPI
  class Paginator
    include Enumerable
    include XIVAPI::HTTP

    # @param client [XIVAPI::Client] Client that is sending the request
    # @param params [Hash] Query parameters
    # @param endpoint [String] API endpoint
    # @param limit [Integer] Total number of results to limit to
    # @param per_page [Integer] Number of results per page, defaults to limit
    def initialize(client, params, endpoint, limit, per_page = limit)
      @client = client
      @params = params.merge(limit: per_page)
      @endpoint = endpoint
      @limit = limit
    end

    def each
      total = 0
      next_page = 1

      while next_page && total < @limit
        page = self.next(next_page)
        page.results.take(@limit - total).each { |result| yield result }
        next_page = page.next_page
        total += page.results.size
      end
    end

    def next(page)
      response = request(@client, @endpoint, @params.merge(page: page))
      Page.new(response)
    end
  end
end
