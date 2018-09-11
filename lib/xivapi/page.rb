module XIVAPI
  class Page
    attr_reader :results, :next_page

    def initialize(response)
      @results = response.results
      pagination = response.pagination
      @next_page = pagination.page_next unless pagination.page == pagination.page_total
    end
  end
end
