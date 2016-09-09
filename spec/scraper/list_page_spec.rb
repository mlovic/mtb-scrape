require 'mechanize'
require_relative '../spec_helper'
require 'scraper/list_page'
require 'scraper/foromtb'

RSpec.describe ListPage do
  let(:page) do
    # fix this
    first_page = nil
    VCR.use_cassette('get_first_page') do
      first_page = Mechanize.new.get(ForoMtb::FOROMTB_URI)
    end
    first_page.extend ListPage
  end

  it 'must have @agent and @page vars' do
    expect(page.agent).to_not be_nil
  end

  describe '#posts' do
    it 'returns a list of fmtb_posts' do
      #expect(page.posts.first).to respond_to :sticky?
      expect(page.posts.first).to be_a FmtbPost
    end
    it 'does not include sticky posts by default' do
      expect(page.posts.any?(&:sticky?)).to be false
    end
  end

end
