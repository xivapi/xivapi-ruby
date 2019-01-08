module XIVAPI
  # Paginates XIVAPI results
  class Paginator
    include Enumerable
    include XIVAPI::HTTP

    # @param client [XIVAPI::Client] Client that is sending the request
    # @param params [Hash] Query parameters
    # @param endpoint [String] API endpoint
    # @param limit [Integer] Total number of results to limit to
    # @param body [Hash] Request body (for advanced search)
    # @param per_page [Integer] Number of results per page, defaults to limit
    def initialize(client, params, endpoint, limit, body = nil, per_page = limit)
      @client = client
      @params = params.merge(limit: per_page)
      @endpoint = endpoint
      @limit = limit
      @body = body
    end

    # An enumerator for XIVAPI results
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

    # The next page in the enumeration of results
    def next(page)
      response = request(@client, @endpoint, @params.merge(page: page), @body)
      Page.new(response)
    end
  end
end
