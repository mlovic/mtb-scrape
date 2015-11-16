require_relative 'spec_helper'

# feature?
RSpec.describe ForoMtb do

  # break down scrape method. CAn't test properly. private methods not adequate
  #  need a scrape post method
  #  need a scrape post preview method
  let(:fmtb) { ForoMtb.new }
  describe '.visit_page' do
    let(:first_page) do
      VCR.use_cassette('get_first_page') { fmtb.visit_page(1) }
    end
    it 'returns a Page' do
      expect(first_page).to be_a Mechanize::Page
    end
    it 'extends ListPage' do
      expect(first_page).to respond_to :posts
    end
    it 'accepts block with number of pages'
  end

end



