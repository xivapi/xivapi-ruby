module XIVAPI::Request
  include XIVAPI::HTTP

  def search(indexes: [], string: '', string_column: 'Name_en', string_algo: 'wildcard_plus',
             page: 1, sort_field: nil, sort_order: nil, limit: 100, filters: [])
    params = { indexes: [*indexes].join(','), string: string, string_column: string_column, string_algo: string_algo,
               page: page, sort_field: sort_field, sort_order: sort_order, filters: [*filters].join(',') }
    XIVAPI::Paginator.new(self, params, 'search', limit)
  end

  def servers
    request(self, 'servers')
  end
end
