require 'faraday'
require 'json'

# API wrapper class
class Zenvelope
  JSON_RPC_VERSION = '2.0'
  RANDOM_ID_SEED = 100_000
  VERSION = '0.2.1'

  attr_reader :auth

  # Subclass that provides the "action", i.e. the "get" in "host.get"
  class Action
    def initialize(verb, parent)
      @verb = verb
      @parent = parent
    end

    def method_missing(method, *args)
      @parent.query([@verb, '.', method].join, args.first)
    end
  end

  def initialize(url = 'http://localhost')
    @auth = nil
    @url = url.chomp('/') + '/api_jsonrpc.php'
  end

  def login(creds = { user: 'Admin', password: 'zabbix' })
    results = query('user.login', creds)
    # return the auth id if successful login, otherwise return false
    @auth = if results.is_a?(String) && /[a-zA-Z0-9]{32}/.match(results)
              results
            else
              false
            end
  end

  def method_missing(method)
    instance_variable_set('@' + method.to_s, Action.new(method, self))
    instance_variable_get('@' + method.to_s)
  end

  def query(method, parameters)
    payload = { id: rand(RANDOM_ID_SEED), jsonrpc: JSON_RPC_VERSION,
                method: method, params: parameters
    }

    payload[:auth] = @auth unless method.include? 'apiinfo'

    begin
      response = JSON.parse(request(payload), symbolize_names: true)
    rescue
      response = {
        error: {
          message: 'Unable to parse JSON response',
          data: "Please check that the path #{@url} is correct."
        }
      }
    end

    if response.key? :error
      response
    else
      response[:result]
    end
  end

  private

  def request(payload)
    conn = Faraday.new(url: @url) do |faraday|
      faraday.adapter :net_http_persistent
      faraday.headers['Content-Type'] = 'application/json'
      faraday.headers['User-Agent'] = "Zenvelope #{VERSION}"
    end

    conn.post { |req| req.body = payload.to_json }.body
  end
end
