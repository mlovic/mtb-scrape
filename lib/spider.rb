require 'benchmark'

class Spider
  # later try with enum instead of num urls

  def initialize(processor, agent = Mechanize.new)
    @processor = processor
    @agent = agent
    logger = Logger.new('mechanize.log')
    logger.level = 'INFO'
    agent.log = logger
    @urls = {}
  end

  def crawl
    until store.empty?
      url, type = store.take

      page = nil
      time = Benchmark.realtime do
        page = @agent.get url
      end

      puts "retrieved #{type} page...  #{page.uri}  in #{time}s"
      if type == :index
        @processor.process_list(page)
      elsif type == :post
        @processor.process_post page, url
      else
        puts url
        raise "Unknown type #{type}"
      end
    end
      # abstract this to just some send_page method
  end

  def enqueue_index(url)
    store.enqueue_index(url)
  end

  def enqueue(url, type)
    #PostUriStore.set(post.url)
    #@urls[url] = type
    # TODO is this right?
  end


  # TODO get rid of this. Follow crawl + enqueue sys
  #def scrape(url)
    #puts 'visiting ' + url + ' ...' 
    #post_page = @agent.get URI.join(ForoMtb::ROOT, url)
    #post_page.extend PostPage
    #return post_page
  #end

  private


    def store
      PostUriStore.instance
    end

end
