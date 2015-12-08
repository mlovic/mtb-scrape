require_relative 'spec_helper'

RSpec.describe DateElementParser do

  # TODO clean this up
  let(:date_element_1) {
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview.html'))
    doc.at('li').extend PostPreview
    date_element = doc.css('.posterDate .DateTime')
  }
  let(:date_element_2) {
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview_2.html'))
    doc.at('li').extend PostPreview
    date_element = doc.css('.posterDate .DateTime')
  }
  let(:date_element_3) {
    doc = Nokogiri::HTML::Document.parse(fixture('post_preview_3.html'))
    doc.at('li').extend PostPreview
    date_element = doc.css('.posterDate .DateTime')
  }
  it 'parses with unix time' do
    expect(DateElementParser.parse(date_element_1).change(sec: 0)).to eq Time.parse('7 Nov 2015 12:59:00 +01:00')
  end
  
  it 'parses without unix time' do
    expect(DateElementParser.parse(date_element_2)).to eq Time.parse('18 May 2015 12:00')
  end
  it 'parses spanish date' do
    expect(DateElementParser.parse(date_element_3)).to eq Time.parse('1 Dec 2015 12:00')
  end


end
