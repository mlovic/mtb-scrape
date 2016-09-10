require_relative 'spec_helper'
require_relative '../mtb_scrape'

RSpec.describe MtbScrape, loads_DB: true do
  #describe '.fmtb_scrape' do
    #it 'works' do
      #pending

      #VCR.use_cassette 'scrape_first_page' do

        #agent = Mechanize.new
        #logger = Logger.new(STDOUT)
        #logger.level = 'INFO'
        #agent.log = logger
        #allow(Mechanize).to receive(:new) {agent}

        #MtbScrape.fmtb_scrape

        #expect(Post.all.size).to eq 20
        #expect(Post.take.description).to_not be_nil
        #expect(Post.take.title).to_not be_nil
        #expect(Post.take.thread_id).to_not be_nil
        #expect(Post.take.posted_at).to_not be_nil
      #end
    #end
  #end

  #describe '.parse_new_or_updated_posts' do
    #pending
    #it 'works' do
      #pending
      #VCR.use_cassette 'scrape_first_page' do

        #MtbScrape.fmtb_scrape

        #MtbScrape.parse_new_or_updated_posts
        #expect(Bike.count).to eq 19
        ## todo here count working??
      #end
    #end
  #end
end
