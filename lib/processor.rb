class Processor
  def initialize
  end

  def process_list(page)
    # posts = site.process_index
    page.extend ListPage
    page.posts.each { |post| eval_post(post) }
  end

  def scrape(num_pages, offset: 1, root: ForoMtb::FOROMTB_URI)
    page_range = get_page_range(num_pages, offset)
    page_range.each do |num|
      # TODO doesn't belong here
      # site.url_for_page(n)
      url = URI.join(root, "page-#{num}")
      store.enqueue_index(url)
    end
    spider.crawl
  end

  def get_page_range(num_pages, offset)
    start_page = offset
    end_page   = offset + num_pages - 1
    (start_page..end_page)
  end

  def process_post(post_page, url)
    post_page.extend PostPage
    # attrs = site.process_page(page)
    post_preview = store.get_prev(url)
    attrs = post_page.all_attrs.merge post_preview.all_attrs
    if db_post = Post.find_by(thread_id: attrs[:thread_id])
      db_post.update(attrs)
      puts "Post #{db_post.id} updated"
    else
      new_post = Post.create!(attrs)
      puts "Post #{new_post.id} created"
    end
  end

  def eval_post(post)
    if new_post?(post) || title_changed?(post)
      #spider.enqueue(post.url, :post)
      store.enqueue_post(post.url, post.preview)
    else 
      update_last_msg(post)
    end
  end

  def title_changed?(post)
    db_post = Post.find_by!(thread_id: post.thread_id)
    p post.title
    p db_post.title
    post.title != db_post.title
  end

  def update_last_msg(post)
    db_post = Post.find_by!(thread_id: post.thread_id)
    unless db_post.last_message_at == post.last_message_at
      puts 'updating last message...'
      db_post.update last_message_at: post.last_message_at
    end
  end

  def new_post?(post)
    !Post.find_by(thread_id: post.thread_id)
  end

  def store
    PostUriStore.instance
  end

  def spider
    @spider ||= Spider.new(self)
  end

end
