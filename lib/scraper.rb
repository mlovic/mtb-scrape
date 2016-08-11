require 'uri'
require 'mechanize'

require_relative 'list_page_handler'
require_relative 'post_page_handler'
require_relative 'processor'
require_relative 'foromtb'

class Scraper
  def initialize
  end

  def scrape(num_pages, options = {})
    offset = options[:start_page] || 1
    page_range = get_page_range(num_pages, offset) 

    Thread.abort_on_exception = true

    url_q   = Queue.new
    pages_q = Queue.new
    
    pphandler = PostPageHandler.new(url_q)
    lphandler = ListPageHandler.new(url_q, pphandler)
    processor = Processor.new(pages_q, pphandler, lphandler)

    # TODO where to put this?
    root = ForoMtb::FOROMTB_URI
    page_range.each do |num|
      url = URI.join(root, "page-#{num}") # TODO where to put this?
      # Use symbol instead of class reference? 
      url_q << [url, ListPageHandler]
    end

    # TODO handle errors in spider thread
    spider = Spider.new(Mechanize.new) # get rid of hardcoded limit
    spider.crawl_async(url_q, pages_q) # Async. Starts thread and returns immediately.
    # TODO handle potential deadlock error. Sleep and retry?
    processor.dispatch(*pages_q.pop) until url_q.empty? && 
                                           !spider.waiting_for_response? 
    puts "Done. Closing queues..."
    url_q.close # Triggers Spider thread to exit
    pages_q.close 
  end

  private

    def get_page_range(num_pages, offset)
      start_page = offset
      end_page   = offset + num_pages - 1
      (start_page..end_page)
    end
end
