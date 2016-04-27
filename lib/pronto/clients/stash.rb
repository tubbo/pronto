class StashClient
  include HTTParty
  base_uri URI.join(ENV['STASH_HOST'], '/rest/api/1.0')

  def initialize(**credentials)
    @headers = {
      basic_auth: credentials
    }
  end

  def create_commit_comment(project, repo, file, line, comment)
    self.class.post url, @headers.merge(
      body: {
        content: comment,
        line_to: line,
        filename: file
      }
    )
  end
end
