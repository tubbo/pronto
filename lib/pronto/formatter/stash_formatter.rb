module Pronto
  module Formatter
    class StashFormatter
      attr_reader :host, :user, :pass

      def initialize
        @host = ENV['STASH_HOST']
        @user = ENV['STASH_USERNAME']
        @pass = ENV['STASH_PASSWORD']
      end

      def format(messages, repo, patches)
        commits = messages.uniq.map do |message|
          client.create_comment(
            sha: message.commit_sha,
            body: message.msg,
            path: message.path,
            position: message.line.new_lineno
          )
        end

        "#{commits.compact.count} Pronto messages posted to Stash"
      end

      private

      def client
        @client ||= Stash::Client.new(
          host: @host, username: @user, password: @pass
        )
      end
    end
  end
end
