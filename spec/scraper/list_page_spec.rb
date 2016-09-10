require 'nokogiri'
require 'scraper/list_page'
require_relative '../helpers'

include Helpers

RSpec.describe ListPage do
  before(:all) do
    doc = Nokogiri::HTML::Document.parse(fixture('first_page.html'))
    @list_page = doc.extend(ListPage)
    @list_page.freeze
  end

  describe '#posts' do
    it 'returns a list of post previews' do
      expect(@list_page.posts.first).to be_a PostPreview
    end

    it 'does not include sticky posts by default' do
      expect(@list_page.posts.any?(&:sticky?)).to be false
    end

    it 'include sticky posts with :with_sticky option' do
      expect(@list_page.posts(with_sticky: true).any?(&:sticky?)).to be true
    end
  end

end
