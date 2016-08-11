require_relative 'spec_helper'

RSpec.describe Scraper do
  describe '#scrape' do
    it 'works' do

      VCR.use_cassette 'scrape_first_page' do

        agent = Mechanize.new
        logger = Logger.new(STDOUT)
        logger.level = 'INFO'
        agent.log = logger
        allow(Mechanize).to receive(:new) {agent}

        scraper = Scraper.new
        scraper.scrape(1)

        expect(Post.all.size).to eq 20
        expect(Post.take.description).to_not be_nil
        expect(Post.take.title).to_not be_nil
        expect(Post.take.thread_id).to_not be_nil
        expect(Post.take.posted_at).to_not be_nil
      end
    end
  end
end
