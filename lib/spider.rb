class Spider
  # later try with enum instead of num urls

  def initialize(processor, agent)
    @processor = processor
    @agent = agent
  end

  def visit_page(num, root)
    page = @agent.get URI.join(root, "page-#{num}")
    puts "retrieved main page...  #{page.header["content-length"]}"
    page.extend ListPage
    page.agent = @agent
    return page
  end

  def crawl(num_pages, offset: 1, root:)
    page_range = get_page_range(num_pages, offset)
    page_range.each do
      page = visit_page(1, root)
      @processor.process_list(page)
    end
  end

  def scrape(post)
    post_page = post.get_post_page
    @processor.process_post(post_page, post.preview)
  end

  private

    def get_page_range(num_pages, offset)
      start_page = offset
      end_page   = offset + num_pages - 1
      (start_page..end_page)
    end

    def enqueue(post)
      PostUriStore.set(post.url)

      # TODO is this right?
    end

end
