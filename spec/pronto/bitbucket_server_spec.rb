module Pronto
  describe BitbucketServer do
    let(:bitbucket) { described_class.new(repo) }

    let :remote_urls do
      ['ssh://git@stash.tools.mycompany.com:7999/mmozuras/pronto.git']
    end

    let(:repo) do
      double(remote_urls: remote_urls, branch: nil)
    end
    let(:sha) { '61e4bef' }
    let(:comment) { double(content: 'note', filename: 'path', line_to: 1, position: 1) }

    before do
      Config.any_instance.should_receive(:bitbucket_slug).and_return('mmozuras/pronto')
    end

    describe '#slug' do
      let(:repo) { double(remote_urls: remote_urls) }
      subject { bitbucket.commit_comments(sha) }

      context 'git remote without .git suffix' do
        specify do
          BitbucketServerClient.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha)
            .once
            .and_return([comment])

          subject
        end
      end
    end

    describe '#commit_comments' do
      subject { bitbucket.commit_comments(sha) }

      context 'three requests for same comments' do
        specify do
          BitbucketServerClient.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { bitbucket.pull_comments(sha) }

      context 'three requests for same comments' do
        specify do
          BitbucketClient.any_instance
            .should_receive(:pull_requests)
            .once
            .and_return([])

          BitbucketClient.any_instance
            .should_receive(:pull_comments)
            .with('mmozuras/pronto', 10)
            .once
            .and_return([comment])

          ENV['PULL_REQUEST_ID'] = '10'

          subject
          subject
          subject
        end
      end
    end
  end
end
