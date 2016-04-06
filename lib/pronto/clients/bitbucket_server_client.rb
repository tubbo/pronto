class BitbucketServerClient
  include HTTParty
  #base_uri "https://api.bitbucket.org/1.0"

  def initialize(username, password, hostname)
    self.base_uri = hostname
    @credentials = { username: username, password: password }
    @headers = { basic_auth: @credentials }
  end

  def commit_comments(slug, sha, options={})
    options.merge!(@headers)
    response = self.class.get("/repositories/#{slug}/commits/#{sha}/comments", options)
    openstruct(response.parsed_response)
  end

  def create_commit_comment(slug, sha, body, path, position, runner = nil, commit_sha = nil, options={})
    options.merge!(@headers)
    options[:body] = {
      content: body,
      line_to: position,
      filename: path
    }
    self.class.post("/repositories/#{slug}/commits/#{sha}/comments", options)
  end

  def pull_comments(slug, pr_id, options={})
    options.merge!(@headers)
    response = self.class.get("/repositories/#{slug}/pull-requests/#{pr_id}/comments", options)
    openstruct(response.parsed_response)
  end

  def pull_requests(slug, options={})
    options.merge!(@headers)
    response = self.class.get("https://api.bitbucket.org/2.0/repositories/#{slug}/pull-requests?state=OPEN", options)
    openstruct(response.parsed_response['values'])
  end

  def create_pull_comment(slug, pull_id, body, sha, path, position, options={})
    options.merge!(@headers)
    options[:body] = {
      content: body,
      line_to: position,
      filename: path
    }
    self.class.post("/repositories/#{slug}/pull-requests/#{pull_id}/comments", options)
  end

  def openstruct(response)
    response.map { |r| OpenStruct.new(r) }
  end
end
