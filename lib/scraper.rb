#require 'benchmark'
#time = Benchmark.measure do
#end
#puts "total: " + time.to_s

class Scraper
  def initialize
    @processor = Processor.new
    @spider = Spider.new(@processor)
  end

  def scrape(num_pages, options)
    offset = options[:start_page] || 1
    page_range = get_page_range(num_pages, offset) 

    root = ForoMtb::FOROMTB_URI
    page_range.each do |num|
      # TODO doesn't belong here
      # site.url_for_page(n)
      url = URI.join(root, "page-#{num}")
      @spider.enqueue_index(url)
    end
    @spider.crawl


    # TODO log: 
    # puts "#{new_posts.size} new posts in db"
    # puts "Oldest last message in db: #{Post.oldest_last_message.to_s}"
    # puts "Oldest last message seen: #{Post.order('updated_at DESC').first.last_message_at.to_s}"
    # try where(nil).size
    # TODO not working. Error from Arel. Maybe ruby 2.3 thing?  `rescue in visit': Cannot visit ThreadSafe::Array (TypeError)   
    # puts "#{Post.count} total posts in db"
    # puts "#{post_update_count} posts updated in db"
  rescue
    unless Bike.find_by(post_id: Post.last&.id)
      puts 'There are posts in the database that need to be parsed'
      puts "Try\n\n\tthor mtb_scrape:parse_lonely_posts\n\n"
    end
    raise
  end

  #def scrape(num_pages, offset: 1, root: ForoMtb::FOROMTB_URI)
    #page_range.each do |num|
      ## TODO doesn't belong here
      ## site.url_for_page(n)
      #url = URI.join(root, "page-#{num}")
      #spider.enqueue_index(url)
    #end
    #spider.crawl
  #end

  private
  def get_page_range(num_pages, offset)
    start_page = offset
    end_page   = offset + num_pages - 1
    (start_page..end_page)
  end


end
