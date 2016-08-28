require_relative 'list_page'
require_relative '../post'

class ListPageHandler
  # TODO move to parent class?
  def initialize(queue, post_page_handler)
    @download_queue = queue
    @post_page_handler = post_page_handler
  end

  # Or just generic 'call' method name?
  def process_page(page)
    page.extend ListPage
    page.posts.each { |post| eval_post(post) }
  end

  # eval_preview?
  # TODO test
  def eval_post(post)
    if new_post?(post) 
      download(post)
    elsif title_changed?(post)
      post.title.match(/vendid/i) ? Post.update(closed: true) : download(post)
    else 
      update_last_msg(post)
    end
  end

  def download(post)
    @download_queue << [post.url, @post_page_handler.class] # tuple?
    # TODO distinguish between post and ppreview
    # TODO now using mech::page with postpreview mixin. Use fmtbPost?
    @post_page_handler.add_post_preview(post.url, post.preview)
  end

  def new_post?(post)
    !Post.find_by(thread_id: post.thread_id)
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

end
