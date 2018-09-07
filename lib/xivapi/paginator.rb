module XIVAPI
  class Paginator
    include Enumerable
    include XIVAPI::HTTP

    def initialize(client, params, endpoint, limit)
      @client = client
      @params = params.merge(limit: [limit, 100].min)
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
      response = request('search', @params.merge(page: page))
      Page.new(JSON.parse(response))
    end
  end
end
