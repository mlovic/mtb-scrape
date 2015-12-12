require_relative 'init'
#require_relative 'lib/post_parser'
#require_relative 'lib/foromtb'
#require_relative 'lib/post'
#require_relative 'lib/post_preview'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

module MtbScrape

  ActiveRecord::Base.logger = Logger.new('db/debug.log')
  configuration = YAML::load(IO.read('db/database.yml'))
  ActiveRecord::Base.establish_connection(configuration['development'])

  # Not being used
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

  def self.fmtb_scrape(num_pages = 1, options = {})

    start_page = options[:start_page] || 1
    end_page = start_page + num_pages - 1


    (start_page..end_page).each do |i|

      puts "Visiting page #{i}..."
      page = ForoMtb.new.visit_page(i)
      page.posts.each do |p|

        #puts "#{@current_thread}: #{p.title}"
        puts p.title

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
  end



  ROOT_DIR = '/home/marko/mtb_scrape'
end

require 'pp'
