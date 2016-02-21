class Processor
  def initialize
  end

  def process_list(page)
    page.posts.each { |post| eval_post(post) }
  end

  def scrape(num_pages, offset: 1, root: ForoMtb::FOROMTB_URI)
    spider.crawl(num_pages, offset: offset, root: root)
  end

  def process_post(post_page, url)
    post_preview = store.get_prev(url)
    attrs = post_page.all_attrs.merge post_preview.all_attrs
    new_post = Post.new(attrs)
    new_post.save!
    puts "  #{new_post.id}"
  end

  def eval_post(post)
    if new_post?(post)
      # TODO PROBLEM: how to keep track of post prev
      #spider.enqueue(post.url, :post)
      store.enqueue_post(post.url, post.preview)
      #post_page = spider.scrape(post.url)
      #process_post(post_page, post.preview)
    else 
      update_post(post)
    end
  end

  def title_changed?(post)
    db_post = Post.find_by!(thread_id: post.thread_id)
    p post.title
    p db_post.title
    post.title != db_post.title
  end

  def update_post(post)
    if title_changed?(post)
      puts 'title changed!'
      db_post = Post.find_by!(thread_id: post.thread_id)
      post_page = spider.scrape(post.url)
      attrs = post_page.all_attrs.merge post.preview.all_attrs
      db_post.update(attrs)
      # TODO should pass only url
      # fix preview too
    else
      update_last_msg(post)
    end
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
