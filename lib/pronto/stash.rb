require "net/http"
require "json"

module Stash
  class Client
    def initialize(host: 'stash.atlassian.com', username: '', password: '')
      @host = host
      @credentials = [username, password].join(':')
      @http = Net::HTTP.new(@host, 443)
      @http.basic_auth(@credentials)
    end

    def create_comment(params)
    end
  end
end
