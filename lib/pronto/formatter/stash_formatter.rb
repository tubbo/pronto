module Pronto
  module Formatter
    class StashFormatter
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
          host: ENV['STASH_HOST'],
          username: ENV['STASH_USERNAME'],
          password: ENV['STASH_PASSWORD']
        )
      end
    end
  end
end
