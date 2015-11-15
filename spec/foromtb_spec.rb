require_relative 'spec_helper'

# feature?
RSpec.describe ForoMtb do
  # break down scrape method. CAn't test properly. private methods not adequate
  #  need a scrape post method
  #  need a scrape post preview method
  describe 'scrape' do
    it 'creates 20 posts in the db' do
      # multiple http requests
      VCR.use_cassette 'scrape_first_page' do
        expect(Post.all.size).to eq 0
        fmtb = ForoMtb.new
        fmtb.scrape_page(1)
        expect(Post.all.size).to eq 20
      end
    end
  end
end
