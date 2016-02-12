class Processor
  def initialize
  end

  def process_list(page)
    page.posts.each { |post| eval_post(post) }
  end

  def process_post(post_page, post_preview)
    attrs = post_page.all_attrs.merge post_preview.all_attrs
    new_post = Post.new(attrs)
    new_post.save!
    puts "  #{new_post.id}"
  end

  def eval_post(post)
    if new_post?(post)
      spider.scrape(post)
    else 
      update_post(post)
    end
  end

  def title_changed?(post)
    db_post = Post.find_by!(thread_id: post.thread_id)
    post.title == db_post.title
  end

  def update_post(post)
    if title_changed?(post)
      # TODO should pass only url
      spider.scrape(post)
    else
      update_last_msg(post)
    end
  end

  def update_last_msg(post)
    db_post = Post.find_by!(thread_id: post.thread_id)
    unless db_post.last_message_at == post.last_message_at
      db_post.update last_message_at: post.last_message_at
    end
  end

  def new_post?(post)
    !Post.find_by(thread_id: post.thread_id)
  end

  def spider
    @spider ||= Spider.new(self, Mechanize.new)
  end

end
