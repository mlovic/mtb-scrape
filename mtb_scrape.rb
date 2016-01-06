#require_relative 'init'
#require_relative 'lib/post_parser'
#require_relative 'lib/foromtb'
#require_relative 'lib/post'
#require_relative 'lib/post_preview'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

module MtbScrape

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

  def self.create_new_bikes(posts)
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
    end
  end

  def self.create_new_brand(name)
    Brand.create(name: name, confirmation_status: 1)
  end

  def self.fmtb_scrape(num_pages = 1, options = {})

    start_page = options[:start_page] || 1
    end_page = start_page + num_pages - 1

    new_posts = []

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
          new_posts << new_post
        else
          p new_post
        end
      end
    end

    puts "#{new_posts.size} new posts in db"
    puts "#{Post.all.size} total posts in db"
    return new_posts
  end



  ROOT_DIR = '/home/marko/mtb_scrape'
end
