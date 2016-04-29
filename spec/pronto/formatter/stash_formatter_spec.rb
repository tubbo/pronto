require 'spec_helper'

module Pronto
  module Formatter
    RSpec.describe StashFormatter do
      before do
        Stash::PULL_REQUEST_ID = '1'
      end

      let :formatter do
        StashFormatter.new
      end

      describe '#format' do
        let :messages do
          [
            double(
              commit_sha: '60e64cbf2accf976918eccde80bb55facc16c710',
              msg: 'everything is broken',
              path: 'README.md',
              line: double(new_lineno: 1)
            )
          ]
        end

        let :repo do
          'BAD/estuyo-cookbook'
        end

        let :patches do
          []
        end

        let :message do
          "#{messages.count} Pronto messages posted to Stash"
        end

        specify do
          formatter.format(messages, repo, patches).should == message
        end
      end
    end
  end
end
