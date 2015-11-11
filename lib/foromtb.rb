require 'mechanize'
require 'sqlite3'
require 'pp'
require 'active_record'
require 'date'

require_relative 'post'

class ForoMtb

  FOROMTB_URI = 'http://www.foromtb.com/forums/btt-con-suspensi%C3%B3n-trasera.60/'
  # PROBLEM: DOES NOT WORK WITH FIRST PAGE: to do with sticky notes

  def scrape_page(page_num, num_posts = nil)
    
    visit_page(page_num)

    nodes = @page.root.css('.discussionListItem')
    puts "#{nodes.size} nodes found"

    remove_sticky!(nodes)

    nodes = nodes.take(num_posts) if num_posts
    count = 0
    nodes.each do |n|

      @current_thread = n.attr(:id).split('-').last.to_i
      puts "#{@current_thread}: #{post_preview_title(n)}"

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
      unix_time = n.css('.lastPost .DateTime').attr('data-time').value.to_i
      @last_message_time = Time.at(unix_time).to_datetime
      if Post.where(thread_id: @current_thread).size > 0
        puts 'Post already in db'
        post = Post.where(thread_id: @current_thread).first #take?
        unless @last_message_time == post.last_message_at
          post.last_message_at = @last_message_time
          puts "Updated last message time (#{post_id})" if post.save
        end
        next
      end
      puts 'passed if'
      post_page = get_post_page(n)

      # Scrape post attributes
      post_attributes = get_post_attributes(post_page)

      # Create post in db
      new_post = Post.new(post_attributes)
      # Skip post if already in db
      # TODO change to activerecord validation
      if Post.where(title: new_post.title).size > 0
        puts 'Post already exists in database!'
        next
      end
      puts "Post created: #{new_post.title}"
      if new_post.save
        puts 'Post saved successfully'
        count = count + 1
      end
      puts "#{Post.all.size} posts in db"
      puts "#{count} new posts in db"
    end

    # List posts in db
    end

  private

  # TODO get_page(number)
    def visit_page(num)
      @agent = Mechanize.new
      p URI.join(FOROMTB_URI, "page-#{num}")
      @page = @agent.get URI.join(FOROMTB_URI, "page-#{num}")
      #@page = @agent.get FOROMTB_URI
      puts 'retrieved main page...'
    end

    def get_post_page(node)
      l = node.css('.PreviewTooltip').first # try css_at without the .first
      link = Mechanize::Page::Link.new(l, @agent, @page)
      link.click
    end

    # Get rid of sticky posts
    # NOT WORKING
    def remove_sticky!(nodes)
      # come up with .sticky? method
      #   and with .title method
      #   PostPreview mixin to extend node?
      nodes.each do |n|
        #pp n
        #nodes.each { |t| p t.css('.title').text.strip } # post_preview_ttle
        #puts "Evaluating #{post_preview_title(n)}... #{n.attributes["class"].value}"
        if n && n.attributes["class"].value.include?('sticky')
          nodes.delete(n)
          puts 'Sticky removed: ' + post_preview_title(n)
        end
      end
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

    def post_preview_title(n)
      n.css('.title').text.strip
    end

end

