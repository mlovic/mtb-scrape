class Processor
  def initialize
  end

  # should extract processing into Processor class,
  # which should be isolated from spider
  # Keep this one to talk to spider and processor
  # and handle concurrency if necessary

  def process_list(page)
    # posts = site.process_index
    page.extend ListPage
    page.posts.each { |post| eval_post(post) }
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

  ### POST
  #
  def process_post(page, url)
    attrs = get_post_data(page, url)
    process_post_data(attrs)
  end
  
  def get_post_data(page, url)
    # TODO page should carry url
    page.extend PostPage
    # attrs = site.process_page(page)
    post_preview = store.get_prev(url)
    attrs = page.all_attrs.merge post_preview.all_attrs
  end

  def process_post_data(attrs)
    if db_post = Post.find_by(thread_id: attrs[:thread_id])
      update_post(attrs, db_post)
    else
      create_post(attrs)
    end
  end

  def update_post(attrs, db_post) 
    # TODO keep title if vendida
    #if db_post.title == attrs[title]
    puts db_post.title
    db_post.update(attrs)
    puts "Post #{db_post.id} updated"
    puts attrs[:title]
  end

  def create_post(attrs)
    new_post = Post.create!(attrs)
    puts "Post #{new_post.id} created"
  end

  def store
    PostUriStore.instance
  end

  def spider
    @spider ||= Spider.new(self)
  end

end
