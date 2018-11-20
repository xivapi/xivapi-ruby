module XIVAPI
  # A single page of results from XIVAPI
  class Page
    # @return the results
    attr_reader :results

    # @return [Integer] the page number of the next results
    attr_reader :next_page

    # Creates an object for storing a Page of results from XIVAPI
    # @param response The response of an HTTP request
    def initialize(response)
      @results = response.results
      pagination = response.pagination
      @next_page = pagination.page_next unless pagination.page == pagination.page_total
    end
  end
end
