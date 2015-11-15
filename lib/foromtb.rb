require 'mechanize'
require 'sqlite3'
require 'pp'
require 'active_record'
require 'date'

require_relative 'post'
require_relative 'post_preview'
require_relative 'post_page'

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

      # IDEAS TO IMPROVE THIS
      # ================
      # Inherit html_post from noko::node. Add methods to get info and shit.
      # OR extend noko::node with post_node module. 
      # Ex: post_node = node.extend PostNode
      #     post_node.get_last_msg_time
      #
      # Separately write PostNode class. pn = PostNode.new(Noko::Node). 
      #                                  Post.new pn.scrape (hash)
      #
      # Separate scraper class: Scraper.scrape(node)
      #

  def scrape_page(page_num, num_posts = nil)
    
    visit_page(page_num)

    nodes = @page.root.css('.discussionListItem')
    nodes.each { |n| n.extend PostPreview }

    nodes = nodes.take(num_posts) if num_posts
    nodes.each do |n|

      next if n.sticky?

      @current_thread = n.thread_id
      puts "#{@current_thread}: #{n.title}"

      # TODO change to activerecord validation?
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

      post_page = get_post_page(n)

      # Scrape post attributes
      post_attributes = get_post_attributes(post_page)

      # Create post in db
      new_post = Post.new(post_attributes)
      puts "Post created successfully: #{new_post.title}" if new_post.save
    end

    puts "#{Post.all.size} posts in db"

  end

  private

  # TODO get_page(number)
    def visit_page(num)
      @agent = Mechanize.new
      @page = @agent.get URI.join(FOROMTB_URI, "page-#{num}")
      puts "retrieved main page...  #{@page.header["content-length"]}"
    end

    def get_post_page(node)
      l = node.css('.PreviewTooltip').first # try css_at without the .first
      link = Mechanize::Page::Link.new(l, @agent, @page)
      link.click
    end

    def get_post_attributes(page)
      # TODO created at attr
      #attributes[:created_at] = page.root.css('abbr .DateTime').attr(:data-time)
      page.extend PostPage
      attributes = page.all_attributes
      attributes[:thread_id] = @current_thread # TODO make this better
      attributes[:last_message_at] = @last_message_time
      return attributes
    end

end

