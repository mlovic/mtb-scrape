#require 'spec_helper'
require 'mechanize'
require 'scraper/spider'
#require_relative '../lib/scraper/processor'
#require_relative '../lib/scraper/foromtb'

RSpec.describe Spider do
  let(:agent) { Mechanize.new }
  # could later stub agent with fmtb page fixture and get rid of vcr
  let(:spider) { Spider.new(processor, agent) }

  describe '#crawl' do
    it 'adds post uris to PostStore' do
      VCR.use_cassette 'scrape_first_page' do
        #expect(PostUriStore).to receive(:set).at_least(:once) { "OK" }
        #expect(processor).to receive(:process_list).twice

        spider.crawl(1, root: ForoMtb::FOROMTB_URI)
      end
    end
  end

  describe '#visit_page' do
    let(:first_page) do
      VCR.use_cassette('get_first_page') { spider.visit_page(1, ForoMtb::FOROMTB_URI) }
    end

    it 'extends ListPage' do
      expect(first_page).to respond_to :posts
    end
  end
end
