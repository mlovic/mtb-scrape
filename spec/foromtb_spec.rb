require_relative 'spec_helper'

# feature?
RSpec.describe ForoMtb do
  # break down scrape method. CAn't test properly. private methods not adequate
  #  need a scrape post method
  #  need a scrape post preview method
  describe '.visit_page' do
    it 'returns a ListPage' do
      ForoMtb.visit_page(1).class eq ForoMtb::ListPage
    end
    it 'accepts block with number of pages'
  end
    
  end
  end
  describe 'scrape' do
    it 'creates 20 posts in the db' do
      # multiple http requests
      VCR.use_cassette 'scrape_first_page' do
        expect(Post.all.size).to eq 0
        fmtb = ForoMtb.new
        fmtb.scrape_page(1)
        expect(Post.all.size).to eq 20
      end
    it 'saves posts with all values' do
      post = Post.take
      expect(post.title).to_not eq nil
      expect(post.thread_id).to_not eq nil
      expect(post.description).to_not eq nil
      #expect(post.).to_not eq nil
    end
  end
end
