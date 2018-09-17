module XIVAPI::Request
  include XIVAPI::HTTP

  LODESTONE_LIMIT = 50.freeze
  ALL_CHARACTER_DATA = 'AC,FR,FC,FCM,PVP'.freeze

  # Search
  def search(indexes: [], string: '', string_column: 'Name_en', string_algo: 'wildcard_plus',
             sort_field: nil, sort_order: nil, limit: 100, filters: [], columns: [])
    params = { indexes: [*indexes].join(','), string: string, string_column: string_column, string_algo: string_algo,
               sort_field: sort_field, sort_order: sort_order, filters: [*filters].join(','), columns: [*columns].join(',') }
    XIVAPI::Paginator.new(self, params, 'search', limit)
  end

  # Content
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

  # Character
  def character(id: nil, all_data: false, poll: false, columns: [])
    params = { data: all_data ? ALL_CHARACTER_DATA : nil, columns: [*columns].join(',') }
    request_cached(self, "character/#{id}", :character, params, poll)
  end

  def character_search(name: nil, server: nil, columns: [])
    params = { name: name, server: server&.capitalize, columns: [*columns].join(',') }
    XIVAPI::Paginator.new(self, params, 'character/search', LODESTONE_LIMIT)
  end

  def character_delete(id: nil, duplicate_id: nil)
    params = { duplicate: duplicate_id }
    !!request(self, "character/#{id}/delete", params)
  end

  def character_update(id: nil)
    request(self, "character/#{id}/update") == 1
  end

  def character_verified?(id: nil)
    request(self, "character/#{id}/verification").verification_token_pass
  end
end
