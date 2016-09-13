require 'nokogiri'
require 'scraper/date_element_parser'
require 'scraper/post_preview'
require_relative '../helpers'

include Helpers

RSpec.describe DateElementParser do

  def build_date_element(fixture_path)
    doc = Nokogiri::HTML::Document.parse(fixture(fixture_path))
    doc.at('li').extend PostPreview
    doc.css('.posterDate .DateTime')
  end

  let(:date_element_1) { build_date_element('post_preview.html') }
  let(:date_element_2) { build_date_element('post_preview_2.html') }
  let(:date_element_3) { build_date_element('post_preview_3.html') }

  it 'parses with unix time' do
    expect(DateElementParser.parse(date_element_1)).to be_within(1).of Time.parse('7 Nov 2015 12:59:20 +01:00')
  end
  
  it 'parses without unix time' do
    expect(DateElementParser.parse(date_element_2)).to be_within(1).of Time.parse('18 May 2015 12:00')
  end
  it 'parses spanish date' do
    expect(DateElementParser.parse(date_element_3)).to be_within(1).of Time.parse('1 Dec 2015 12:00')
  end

end
