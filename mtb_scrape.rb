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
      # use count when possible
    end
  end

  def self.reset_bikes
    # come up with method that tracks changes. At least number of records changed
    Bike.delete_all
    puts 'All bikes deleted'
    Post.all.each do |post|
      attributes = PostParser.parse(post)
      next if attributes[:buyer]
      # TODO pass attrs hash to bike
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

  def self.parse_virgin_posts
    # TODO somehow consolidate with updater
    counter = 0
    Post.not_parsed.each do |post|
      attributes = PostParser.parse(post)
      next if attributes[:buyer]
      bike = Bike.new(attributes)
      bike.post = post
      bike.save!
      counter += 1
    end
    puts "parsed #{counter} new posts"
  end

  def self.update(num_pages = 5)
    # really only have to go to last_message_at of last in db
    new_posts = fmtb_scrape(num_pages) # 5? think about this
    parse_virgin_posts
  end

  def self.create_new_bikes(posts = nil)
    bike_count = 0
    posts ||= Post.wherebike # what is this?
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

    spider = Spider.new(Processor.new, Mechanize.new)
    spider.crawl(num_pages, offset: start_page, root: ForoMtb::FOROMTB_URI)

    # TODO log: 
    # puts "#{new_posts.size} new posts in db"
    # puts "Oldest last message in db: #{Post.oldest_last_message.to_s}"
    # puts "Oldest last message seen: #{Post.order('updated_at DESC').first.last_message_at.to_s}"
    # try where(nil).size
    # TODO not working. Error from Arel. Maybe ruby 2.3 thing?  `rescue in visit': Cannot visit ThreadSafe::Array (TypeError)   
    # puts "#{Post.count} total posts in db"
    # puts "#{post_update_count} posts updated in db"
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
