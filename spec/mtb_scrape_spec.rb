require_relative 'spec_helper'

RSpec.describe MtbScrape do
  describe '.fmtb_scrape' do
    it 'works' do

      VCR.use_cassette 'scrape_first_page' do

        MtbScrape.fmtb_scrape

        expect(Post.all.size).to eq 20
        expect(Post.take.description).to_not be_nil
        expect(Post.take.title).to_not be_nil
        expect(Post.take.thread_id).to_not be_nil
        expect(Post.take.posted_at).to_not be_nil
      end
    end
  end

  describe '.parse_virgin_posts' do
    it 'works', focus: true do
      VCR.use_cassette 'scrape_first_page' do

        MtbScrape.fmtb_scrape

        MtbScrape.parse_virgin_posts
        expect(Bike.count).to eq 19
        # todo here count working??
      end
    end
  end
end
