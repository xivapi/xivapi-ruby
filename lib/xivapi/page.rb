module XIVAPI
  class Page
    attr_reader :results, :next_page

    def initialize(response)
      @results = response['Results']
      @next_page = response['Pagination']['PageNext']
    end
  end
end
