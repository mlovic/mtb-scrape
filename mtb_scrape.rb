#require_relative 'init'
#require_relative 'lib/post_parser'
#require_relative 'lib/foromtb'
#require_relative 'lib/post'
#require_relative 'lib/post_preview'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }


module MtbScrape

  logger = Logger.new(STDOUT)

  def log(arg)
    logger.info arg
  end
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

  def self.reset_bikes
    # come up with method that tracks changes. At least number of records changed
    Bike.delete_all
    puts 'All bikes deleted'
    Post.all.each do |post|
      attributes = PostParser.parse(post)
      next if attributes[:buyer]
      bike = Bike.new(price: attributes[:price], 
                      frame_only: attributes[:frame_only],
                      size: attributes[:size],
                      brand_id: attributes[:brand_id],
                      model_id: attributes[:model_id],
                      post_id: post.id
                     )
      bike.save!
    end
  end

  def self.update(num_pages = 5)
    new_posts = fmtb_scrape(num_pages) # 5? think about this
    create_new_bikes(new_posts)
  end

  def self.create_new_bikes(posts = nil)
    bike_count = 0
    posts ||= Post.wherebike
    posts.each do |post|
      attributes = PostParser.parse(post)
      next if attributes[:buyer]
      bike = Bike.new(price: attributes[:price], 
                      frame_only: attributes[:frame_only],
                      size: attributes[:size],
                      brand_id: attributes[:brand_id],
                      model_id: attributes[:model_id],
                      post_id: post.id
                     )
      bike.save!
      bike_count += 1
    end
    puts "#{bike_count} new bikes in db"
  end

  def self.create_new_brand(name)
    Brand.create(name: name, confirmation_status: 1)
  end

  def self.fmtb_scrape(num_pages = 1, options = {})

    start_page = options[:start_page] || 1
    end_page = start_page + num_pages - 1

    new_posts = []
    post_update_count = 0

    (start_page..end_page).each do |i|

      puts "Visiting page #{i}..."
      page = ForoMtb.new.visit_page(i)
      page.posts.each do |p|

        #puts "#{@current_thread}: #{p.title}"
        puts p.title

        if Post.find_by(thread_id: p.thread_id)
          post = Post.find_by!(thread_id: p.thread_id)
          # TODO check if post has been edited. Title at least
          unless p.last_message_at == post.last_message_at
            post.update last_message_at: p.last_message_at
            post_update_count += 1
          end
          next
        end

        # Create post in db
        new_post = Post.new(p.scrape)
        if new_post.save
          puts "Post created successfully: #{new_post.title}" 
          new_posts << new_post
        else
          p new_post
        end
      end
    end

    puts "#{post_update_count} posts updated in db"
    puts "#{new_posts.size} new posts in db"
    # TODO not working. Error from Arel. Maybe ruby 2.3 thing?  `rescue in visit': Cannot visit ThreadSafe::Array (TypeError)   
     #puts "#{Post.count} total posts in db"
    return new_posts
  rescue
    unless Bike.find_by(post_id: Post.last.id)
      puts 'There are posts in the database that need to be parsed'
      puts "Try\n\n\tthor mtb_scrape:parse_lonely_posts\n\n"
    end
    raise
  end
  
  def parse_lonely_posts
    
  end

  def self.parse_posts
    # TODO should re-parse all posts in db
    
  end


  ROOT_DIR = '/home/marko/mtb_scrape'
end
