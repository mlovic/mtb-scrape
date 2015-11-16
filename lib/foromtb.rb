require 'mechanize'
require 'sqlite3'
require 'pp'
require 'active_record'
require 'date'

require_relative 'post'
require_relative 'post_preview'
require_relative 'post_page'
require_relative 'list_page'

class ForoMtb

  # NEW
  #
  # page = visit_page 1
  # page.posts.each # give @posts or load posts if not available
  #   p.associated_post.image?
  #   Post.new p.scrape_all
#   end

  FOROMTB_URI = 'http://www.foromtb.com/forums/btt-con-suspensi%C3%B3n-trasera.60/'

  def initialize
    mech_logger = Logger.new('mechanize.log')
    mech_logger.level = Logger::INFO
    Mechanize.log = mech_logger
  end

  def visit_page(num)
    @agent = Mechanize.new
    page = @agent.get URI.join(FOROMTB_URI, "page-#{num}")
    puts "retrieved main page...  #{page.header["content-length"]}"
    page.extend ListPage
    page.agent = @agent
    return page
  end

      # IDEAS TO IMPROVE THIS
      # ================
      #
  # Seperate foromtb class and post and postlist classes from scraping
  # Scraper class
  #   scrape_posts(pages, etc) do |p|
  #     Post.new(p.scrape)
  #     Post.new(p.scrape) if
  #     # update time
  #   end
  #
  #   def update time
  #   def scrape post
  #
      # S

  def scrape_page(page_num, num_posts = nil)
    
    @page = visit_page(page_num)
    @page.posts.each do |n|

      @current_thread = n.thread_id
      puts "#{@current_thread}: #{n.title}"

      @last_message_time = n.last_message_at
      if Post.find_by(thread_id: @current_thread)
        puts 'Post already in db'
        post = Post.find_by!(thread_id: @current_thread)
        unless @last_message_time == post.last_message_at
          post.last_message_at = @last_message_time
          puts "Updated last message time (#{post.id})" if post.save
        end
        next
      end
      # Create post in db
      new_post = Post.new(n.scrape)
      puts "Post created successfully: #{new_post.title}" if new_post.save
    end

    puts "#{Post.all.size} posts in db"

  end

end

