require 'spec_helper'
#require 'mtb_scrape'

RSpec.describe Spider do
  #let(:store) { double(PostUriStore) }
  let(:processor) { Processor.new }
  let(:agent) { Mechanize.new }
  let(:spider) { Spider.new(processor, agent) }

  before { create(:post) }

  describe 'crawl' do
    it 'adds post uris to PostStore' do
      VCR.use_cassette 'scrape_first_page' do
        #expect(PostUriStore).to receive(:set).at_least(:once) { "OK" }
        #expect(processor).to receive(:process_list).twice

        spider.crawl(1, root: ForoMtb::FOROMTB_URI)
      end
    end
  end
end
