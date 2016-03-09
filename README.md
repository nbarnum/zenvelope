# zenvelope [![Gem Version](https://badge.fury.io/rb/zenvelope.svg)](https://badge.fury.io/rb/zenvelope)
I wanted a Zabbix API wrapper so that I could copy and paste code from
Zabbix's API docs instead of learning whatever quirks library maintainers decided
to build into their implementation.

The result is zenvelope. The `method` and `params` portions of the JSON
requests are used in a transparent way that is meant to be readable and most
importantly, usable without having to read any new docs.

## Installation

```
gem install zenvelope
```

or add to Gemfile:

```
gem 'zenvelope'
```

## Example usage

To demonstrate, I'll follow the example workflow found here: https://www.zabbix.com/documentation/3.0/manual/api

### Authentication

```ruby
require 'zenvelope'

# Use your server's URL
z = Zenvelope.new('http://company.com/zabbix')
z.login(user: 'Admin', password: 'zabbix')
```
Your auth token is stored in the class instance `z` for subsequent API requests.

### Retrieving hosts

You only need to pass in the `params` section of the JSON. The `id` and `auth` are handled for you.

```ruby
z.host.get(output: %w(hostid host), selectInterfaces: %w(interfaceid ip))
# => [{:hostid=>"10084", :host=>"Zabbix server", :interfaces=>[{:interfaceid=>"1", :ip=>"127.0.0.1"}]}]
```

### Creating a new item

```ruby
z.item.create(
  name: 'Free disk space on $1',
  key_: 'vfs.fs.size[/home/joe/,free]',
  hostid: '10084',
  type: 0,
  value_type: 3,
  interfaceid: '1',
  delay: 30
)
# => {:itemids=>["23660"]}
```

### Error handling

```ruby
z.host.create(
  host: 'Linux server',
  interfaces: [
    {
      type: 1,
      main: 1,
      useip: 1,
      ip: '192.168.3.1',
      dns: '',
      port: '10050'
    }
  ]
)
 # => {:jsonrpc=>"2.0", :error=>{:code=>-32602, :message=>"Invalid params.", :data=>"No groups for host \"Linux server\"."}, :id=>70719}
```

## TODO

- testing
- gracefully handling errors
