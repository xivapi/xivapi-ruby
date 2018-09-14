module XIVAPI::Request
  include XIVAPI::HTTP

  LODESTONE_LIMIT = 50.freeze

  def search(indexes: [], string: '', string_column: 'Name_en', string_algo: 'wildcard_plus',
             sort_field: nil, sort_order: nil, limit: 100, filters: [], columns: [])
    params = { indexes: [*indexes].join(','), string: string, string_column: string_column, string_algo: string_algo,
               sort_field: sort_field, sort_order: sort_order, filters: [*filters].join(','), columns: [*columns].join(',') }
    XIVAPI::Paginator.new(self, params, 'search', limit)
  end

  def character(id: nil, data: [], columns: [])
    params = { data: [*data].join(','), columns: [*columns].join(',') }
    request(self, "character/#{id}", params)
  end

  def character_search(name: nil, server: nil)
    params = { name: name, server: server&.capitalize }
    XIVAPI::Paginator.new(self, params, 'character/search', LODESTONE_LIMIT)
  end

  def character_verified?(id)
    request(self, "character/#{id}/verification").verification_token_pass
  end

  def content(name: nil, ids: [], limit: 100, columns: [])
    if name.nil?
      request(self, 'content')
    elsif [*ids].size == 1
      request("#{name.capitalize}/#{[*ids].first}")
    else
      params = { ids: [*ids].join(','), columns: [*columns].join(',') }
      XIVAPI::Paginator.new(self, params, name.capitalize, limit)
    end
  end

  def servers
    request(self, 'servers')
  end
end
