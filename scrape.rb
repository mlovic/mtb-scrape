require 'logger'
require 'active_record'
require 'sqlite3'
require 'mechanize'

require_relative 'lib/foromtb'
require_relative 'lib/post'

ActiveRecord::Base.logger = Logger.new('db/debug.log')
configuration = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

puts 'Posts:'
Post.all.each do |post|
  puts post.title
end

class Scraper
  def self.scrape(num_pages = 1, &block)
    num_pages.times do |n|
      page = ForoMtb.new.visit_page(n+1)
      page.posts.each do |p|
        yield p
      end
    end

    puts "#{Post.all.size} posts in db"
  end
end

(5..10).each do |i|
  page = ForoMtb.new.visit_page(i)
  page.posts.each do |p|

    puts "#{@current_thread}: #{p.title}"

    if Post.find_by(thread_id: p.thread_id)
      post = Post.find_by!(thread_id: p.thread_id)
      unless p.last_message_at == post.last_message_at
        post.update last_message_at: p.last_message_at
      end
      next
    end

    # Create post in db
    new_post = Post.new(p.scrape)
    if new_post.save
      puts "Post created successfully: #{new_post.title}" 
    else
      p new_post
    end
  end
end

puts "#{Post.all.size} posts in db"

# TODO open dataset: mtb index. all bikes: model, year, travel, msrp
