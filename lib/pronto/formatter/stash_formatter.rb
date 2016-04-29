module Pronto
  module Formatter
    class StashFormatter
      def format(messages, slug, patches)
        commits = messages.uniq.map do |message|
          type = 'CONTEXT'
          project, repo = slug.split('/')
          client.create_comment(
            project: project,
            repo: repo,
            text: message.msg,
            #sha: message.commit_sha,
            anchor: {
              line: message.line.new_lineno,
              lineType: type,
              fileType: 'TO',
              path: message.path,
              srcPath: message.path
            }
          )
        end

        "#{commits.compact.count} Pronto messages posted to Stash"
      end

      private

      def client
        @client ||= Stash::Client.new
      end
    end
  end
end
