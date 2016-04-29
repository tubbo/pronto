require 'logger'

module Stash
  HOST = ENV['STASH_HOST']
  USERNAME = ENV['STASH_USERNAME']
  PASSWORD = ENV['STASH_PASSWORD']
  PULL_REQUEST_ID = ENV['STASH_PULL_REQUEST_ID']

  class Client
    include HTTParty

    # base_uri Stash::HOST
    # basic_auth Stash::USERNAME, Stash::PASSWORD
    logger ::Logger.new(STDOUT), :debug, :curl
    headers 'Content-Type' => 'application/json'

    def initialize
      raise ArgumentError, "STASH_HOST must be set"     if Stash::HOST.nil?
      raise ArgumentError, "STASH_USERNAME must be set" if Stash::USERNAME.nil?
      raise ArgumentError, "STASH_PASSWORD must be set" if Stash::PASSWORD.nil?
      self.class.base_uri Stash::HOST
      self.class.basic_auth Stash::USERNAME, Stash::PASSWORD
    end

    def create_comment(project: '', repo: '', text: '', anchor: {})
      raise ArgumentError, "PULL_REQUEST_ID must be set" if Stash::PULL_REQUEST_ID.nil?
      params = { text: text, anchor: anchor }
      puts params
      self.class.post(
        "/rest/api/1.0/projects/#{project}/repos/#{repo}/pull-requests/#{Stash::PULL_REQUEST_ID}/comments",
        params
      )
    end
  end
end
