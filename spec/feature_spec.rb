require_relative 'spec_helper'

RSpec.describe 'scrape all posts' do
  it 'scrapes all posts' do

    expect(Post.take).to be_nil

    VCR.use_cassette 'scrape_first_page' do
      page = ForoMtb.new.visit_page(1)
      page.posts.each do |p|
        Post.create(p.scrape)
      end
    end

    expect(Post.all.size).to eq 20
    expect(Post.take.description).to_not be_nil
    expect(Post.take.title).to_not be_nil
    expect(Post.take.thread_id).to_not be_nil
  end
end

class Scraper
  def self.scrape(num_pages = 1, &block)
    num_pages.times do |n|
      page = ForoMtb.new.visit_page(n+1)
      page.posts.each do |t|
        yield t
      end
    end

    puts "#{Post.all.size} posts in db"
  end
end

describe 'scraper' do
  
  it 'scraper' do
    DatabaseCleaner.clean_with(:truncation)
    expect(Post.take).to be_nil

    VCR.use_cassette 'scrape_first_page' do

      Scraper.scrape do |p|
        Post.create(p.scrape)
        puts p.title
      end

    end

    expect(Post.all.size).to eq 20
    expect(Post.take.description).to_not be_nil
  end

end

        #if Post.find_by(thread_id: p.thread_id)
          #post = Post.find_by!(thread_id: p.thread_id)
          #unless p.last_message_at == post.last_message_at
            #post.update last_message_at: p.last_message_at
          #end
          #next
        #end
        
        #foropost not being passed agent and page on init




