class Spider
  # later try with enum instead of num urls

  def initialize(processor, agent = Mechanize.new)
    @processor = processor
    @agent = agent
    @urls = {}
  end

  def crawl(num_pages, offset: 1, root:)
    page_range = get_page_range(num_pages, offset)
    page_range.each do |num|
      url = URI.join(root, "page-#{num}")
      store.enqueue_index(url)
    end
    puts 'page range set' + page_range.to_s
    until store.empty?
      puts 'looping!'
      url, type = store.take
      page = @agent.get url
      puts "retrieved #{type} page...  #{page.header["content-length"]}"
      if type == :index
        page.extend ListPage
        @processor.process_list(page)
      elsif type == :post
        page.extend PostPage
        @processor.process_post page, url
      else
        puts url
        raise "Unknown type #{type}"
      end
    end
      # maybe check 
      # abstract this to just some send_page method
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

    def get_page_range(num_pages, offset)
      start_page = offset
      end_page   = offset + num_pages - 1
      (start_page..end_page)
    end

    def store
      PostUriStore.instance
    end

end
