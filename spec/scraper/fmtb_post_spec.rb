require 'mechanize'
#require_relative 'spec_helper'
#require_relative '../../lib/scraper/fmtb_post'
require 'scraper/fmtb_post'
require 'scraper/foromtb'
require 'scraper/post_preview'
require_relative '../helpers'
require 'vcr'

include Helpers

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.describe FmtbPost do
  let(:fmtb_post) { 
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview.html')).at('li')
    agent = Mechanize.new
    page = VCR.use_cassette('get_first_page') { agent.get(ForoMtb::FOROMTB_URI) }
    #page = Nokogiri::HTML::Document.parse(fixture('first_page.html'))
    FmtbPost.new doc, page
  }

  let(:sticky_post_preview) {
    doc = Nokogiri::HTML::Document.parse(fixture('sticky_post_preview.html'))
    doc.at('li').extend PostPreview
  }

  it 'should have preview methods' do
    expect(fmtb_post).to respond_to :title
  end

  describe '#sticky' do
    it 'returns true when post is sticky' do
      expect(sticky_post_preview).to be_sticky
    end
    it 'returns false when post is not sticky' do
      expect(fmtb_post).to_not be_sticky
    end
  end

  describe '#thread_id' do
    it 'returns thread id' do
      expect(fmtb_post.thread_id).to eq 1281012
    end
    # raise error if no thread id found?
    # special error for no found
  end

  describe '#last_message_at' do
    it 'returns time of last thread message' do
      expect(fmtb_post.last_message_at).to eq DateTime.parse('11 Nov 2015 07:29:28 +01:00')
    end
  end

  describe 'title' do
    it 'returns post title' do
      expect(fmtb_post.title).to eq 'Santa cruz driver 8'
    end
  end

  describe 'scrape' do
    it 'returns a hash of attrs' do
      # mock scrape
      VCR.use_cassette('scrape_post') do
        expect(fmtb_post.scrape).to be_a Hash
        expect(fmtb_post.scrape.keys).to match_array %i[title description posted_at last_message_at images uri thread_id username visits]
      end

    end
  end

end
