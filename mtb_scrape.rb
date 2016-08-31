Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
require 'mechanize'

module MtbScrape

  logger = Logger.new(STDOUT)

  def log(arg)
    logger.info arg
  end

  def self.parse_new_or_updated_posts
    # TODO somehow consolidate with updater
    # TODO also parse updated posts
    Post.active.not_parsed..each do |post|
      puts "Parsing " + post.title
      attributes = PostParser.parse(post)
      bike = Bike.new(attributes)
      bike.post = post
      bike.save!
    end
    Post.active.updated.each do |post|
      BikeUpdater.update(post.bike.id)
    end
  end

  def self.update(num_pages = 5)
    # really only have to go to last_message_at of last in db
    new_posts = fmtb_scrape(num_pages) # 5? think about this
    parse_new_or_updated_posts
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
    Scraper.new.scrape(num_pages, options)

     #TODO log: 
     #puts "#{new_posts.size} new posts in db"
     #puts "Oldest last message in db: #{Post.oldest_last_message.to_s}"
     #puts "Oldest last message seen: #{Post.order('updated_at DESC').first.last_message_at.to_s}"
     #try where(nil).size
     ##TODO not working. Error from Arel. Maybe ruby 2.3 thing?  `rescue in visit': Cannot visit ThreadSafe::Array (TypeError)   
     #puts "#{Post.count} total posts in db"
    ## puts "#{post_update_count} posts updated in db"
  #rescue
    #unless Bike.find_by(post_id: Post.last&.id)
      #puts 'There are posts in the database that need to be parsed'
      #puts "Try\n\n\tthor mtb_scrape:parse_lonely_posts\n\n"
    #end
    #raise
  end

end
