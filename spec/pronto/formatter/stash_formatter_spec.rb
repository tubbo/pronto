require 'spec_helper'

module Pronto
  module Formatter
    RSpec.describe StashFormatter do
      before do
        ENV['STASH_HOST'] = 'stash.tools.weblinc.com'
        ENV['STASH_USERNAME'] = 'tscott'
        ENV['STASH_PASSWORD'] = 'n/a'
      end

      let :formatter do
        StashFormatter.new
      end

      describe '#initialize' do
        it { formatter.host.should == 'stash.tools.weblinc.com' }
        it { formatter.user.should == 'tscott' }
        it { formatter.pass.should == 'n/a' }
      end

      describe '#format' do
        let :messages do
          [
            double(
              commit_sha: '1a4548b',
              msg: 'done broke the whole app',
              path: 'config/application.rb',
              position: 17
            )
          ]
        end

        let :repo do
        end

        let :patches do
        end

        specify do
          formatter.format(messages, repo, patches).should == "1 Pronto messages posted to Stash"
        end
      end
    end
  end
end
