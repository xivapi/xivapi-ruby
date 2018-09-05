module XIVAPI::Request
  include XIVAPI::HTTP

  def servers
    response = request('servers')
    JSON.parse(response)
  end
end
