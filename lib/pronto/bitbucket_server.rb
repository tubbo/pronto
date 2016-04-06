module Pronto
  class BitbucketServer < Bitbucket
    def client
      @client ||= BitbucketServerClient.new(
        @config.bitbucket_username,
        @config.bitbucket_password,
        @config.bitbucket_hostname
      )
    end
  end
end
