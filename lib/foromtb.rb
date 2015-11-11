require 'mechanize'
require 'sqlite3'
require 'pp'
require 'active_record'
require 'date'

require_relative 'post'
require_relative 'post_preview'

class ForoMtb

  FOROMTB_URI = 'http://www.foromtb.com/forums/btt-con-suspensi%C3%B3n-trasera.60/'
  # PROBLEM: DOES NOT WORK WITH FIRST PAGE: to do with sticky notes
  #
  #
  # Create
  #
  def initialize
    mech_logger = Logger.new('mechanize.log')
    mech_logger.level = Logger::INFO
    Mechanize.log = mech_logger
  end

  def scrape_page(page_num, num_posts = nil)
    
    visit_page(page_num)

    nodes = @page.root.css('.discussionListItem')
    nodes.each { |n| n.extend PostPreview }
    puts "#{nodes.size} nodes found"

    nodes = nodes.take(num_posts) if num_posts
    nodes.each do |n|

      #puts 'found sticky' && next if n.sticky?
      if n.sticky?
        puts 'found sticky in block'
        next
      end

      @current_thread = n.thread_id
      puts "#{@current_thread}: #{n.title}"

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
      #
      #unix_time = n.css('.lastPost .DateTime').attr('data-time').value.to_i
      #@last_message_time = Time.at(unix_time).to_datetime
      # TODO change to activerecord validation?
      @last_message_time = n.last_message_at
      if Post.where(thread_id: @current_thread).size > 0
        puts 'Post already in db'
        post = Post.where(thread_id: @current_thread).first #take?
        unless @last_message_time == post.last_message_at
          post.last_message_at = @last_message_time
          puts "Updated last message time (#{post.id})" if post.save
        end
        next
      end
      puts 'passed if'

      post_page = get_post_page(n)

      # Scrape post attributes
      post_attributes = get_post_attributes(post_page)

      # Create post in db
      new_post = Post.new(post_attributes)
      puts "Post created: #{new_post.title}"
      puts 'Post saved successfully' if new_post.save
    end

    puts "#{Post.all.size} posts in db"

  end

  private

  # TODO get_page(number)
    def visit_page(num)
      @agent = Mechanize.new
      p URI.join(FOROMTB_URI, "page-#{num}")
      @page = @agent.get URI.join(FOROMTB_URI, "page-#{num}")
      puts "retrieved main page...  #{@page.header["content-length"]}"
    end

    def get_post_page(node)
      l = node.css('.PreviewTooltip').first # try css_at without the .first
      link = Mechanize::Page::Link.new(l, @agent, @page)
      link.click
    end

    def get_post_attributes(page)
      attributes = {
        description: page.root.css('.messageList blockquote').first
      }
      attributes[:images] = page.root.css('li.image .filename a').map { |i| i['href'] }
      attributes[:title] = page.at('.titleBar h1').text
      attributes[:uri] = page.uri.to_s
      attributes[:thread_id] = @current_thread # TODO make this better
      attributes[:last_message_at] = @last_message_time
      # TODO created at attr
      #p page.root.css('.titleBar')
      #p page.root.css('.titleBar.DateTime')
      #p page.root.css('.titleBar .DateTime').methods
      #attributes[:created_at] = page.root.css('abbr .DateTime').attr(:data-time)
      return attributes
    end

end

