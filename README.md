# XIVAPI

A Ruby library for [XIVAPI](https://www.xivapi.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xivapi', git: 'https://github.com/xivapi/xivapi-ruby.git', tag: 'v0.1.3'
```

And then run:

```
$ bundle install
```

## Documentation

Full documentation for this library can be found [here](https://xivapi.github.io/xivapi-ruby/). For basic usage information, please see below.

## Usage

Start by initializing a client. You can obtain an API key by creating a new XIVAPI application [here](https://www.xivapi.com/app).

```rb
require 'xivapi'

# Basic configuration
client = XIVAPI::Client.new(api_key: 'abc123')

# Advanced configuration
client = XIVAPI::Client.new(api_key: 'abc123', language: 'en', poll_rate: 5)
```

Now that you have a client, you can use it to contact the API. Examples have been provided below for the various endpoints. For the full list of endpoints and their parameters, please reference the [request documentation](https://xivapi.github.io/xivapi-ruby/XIVAPI/Request.html).

### Response data
The data returned from the API is automatically converted into [OpenStruct](https://ruby-doc.org/stdlib-2.0.0/libdoc/ostruct/rdoc/OpenStruct.html) objects with snake_cased keys. If the request returns multiple results (e.g. character search), it will be provided to you in the form of an `XIVAPI::Paginator` object. The paginator is [Enumerable](https://ruby-doc.org/core-2.4.1/Enumerable.html), allowing you to access the data with methods like `first`, `each`, `map` and `to_a`.

See the examples below to get a better idea of how to access the data.

### Examples
#### Search
```rb
>> achievements = client.search(indexes: 'achievement', string: 'tankless')
=> ...
>> achievements.map(&:name)
=> ["A Tankless Job II (Dark Knight)", "A Tankless Job I (Paladin)", "A Tankless Job I (Warrior)", "A Tankless Job II (Warrior)", "A Tankless Job I (Dark Knight)", "A Tankless Job II (Paladin)"]
>> achievements.first.points
=> 10
```

#### Content
```rb
>> client.content
=> ["Achievement", "AchievementCategory", "AchievementKind", ...]

>> achievement = client.content(name: 'Achievement', limit: 1).first
=> ...
>> achievement.name
=> "To Crush Your Enemies I"

>> achievements = client.content(name: 'Achievement', ids: 4..5)
=> ...
>> achievements.map(&:name)
=> ["To Crush Your Enemies IV", "To Crush Your Enemies V"]
```

#### Servers
```rb
>> client.servers
=> ["Adamantoise", "Aegis", "Alexander", ...]
```

#### Character
```rb
>> characters = client.character_search(name: 'raelys skyborn', server: 'behemoth')
=> ...
>> id = characters.first.id
=> 7660136
>> character = client.character(id: id, all_data: true)
=> ...
>> character.character.name
=> "Raelys Skyborn"
>> character.achievements.list.last.id
=> 692
```

#### Free Company
```rb
>> fcs = client.free_company_search(name: 'lodestone', server: 'behemoth')
=> ...
>> id = fcs.first.id
=> "9234349560946590421"
>> fc = client.free_company(id: id, members: true)
=> ...
>> fc.free_company.name
=> "Lodestone"
>> fc.free_company_members.first.name
=> "Raelys Skyborn"
```

#### Linkshell
```rb
>> linkshells = client.linkshell_search(name: 'thunderbirds', server: 'behemoth')
=> ...
>> id = linkshells.first.id
=> "21955048183495181"
>> linkshell = client.linkshell(id: id, poll: true).linkshell
=> ...
>> linkshell.name
=> "Thunderbirds"
```

#### PVP Team
```rb
>> teams = client.pvp_team_search(name: 'kill', server: 'chaos')
=> ...
>> team = client.pvp_team(id: teams.first.id).pvp_team
=> ...
>> team.name
=> "!Kill_For_A_Friend!"
```

#### Lodestone
```rb
>> updates = client.lodestone(:updates)
=> ...
>> updates.first.title
=> "Companion App Updated (Sep. 18)"
```

#### Patch List
```rb
>> patch = client.patch_list.last
=> ...
>> patch.name
=> "Patch 4.4: Prelude In Violet"
>> Time.at(patch.release_date.to_i)
=> 2018-09-18 10:00:00 +0000
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xivapi/xivapi-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
