class BitbucketServerClient
  include HTTParty

  def initialize(username, password, hostname)
    self.class.base_uri "https://#{hostname}/rest/api/1.0"
    @credentials = { username: username, password: password }
    @headers = { basic_auth: @credentials, 'Content-Type' => 'application/json' }
  end

  def commit_comments(slug, sha, options={})
    options.merge!(@headers)
    project, repo = slug.split '/'
    response = self.class.get("/projects/#{project}/repos/#{repo}/commits/#{sha}/comments", options)
    openstruct(response.parsed_response)
  end

  def create_commit_comment(slug, sha, body, path, position, runner = nil, commit_sha = nil, options={})
    options.merge!(@headers)
    options[:body] = {
      content: body,
      line_to: position,
      filename: path
    }
    project, repo = slug.split '/'
    self.class.post("/projects/#{project}/repos/#{repo}/commits/#{sha}/comments", options)
  end

  def pull_comments(slug, pr_id, options={})
    options.merge!(@headers)
    project, repo = slug.split '/'
    response = self.class.get("/projects/#{project}/repos/#{repo}/pull-requests/#{pr_id}/comments", options)
    openstruct(response.parsed_response)
  end

  def pull_requests(slug, options={})
    options.merge!(@headers)
    project, repo = slug.split '/'
    response = self.class.get("/projects/#{project}/repos/#{repo}/pull-requests?state=OPEN", options)
    openstruct(response.parsed_response['values'])
  end

  def create_pull_comment(slug, pull_id, body, sha, path, position, options={})
    options.merge!(@headers)
    options[:body] = {
      content: body,
      line_to: position,
      filename: path
    }
    project, repo = slug.split '/'
    self.class.post("/projects/#{project}/repos/#{repo}/pull-requests/#{pull_id}/comments", options)
  end

  def openstruct(response)
    response.map { |r| OpenStruct.new(r) }
  end
end
