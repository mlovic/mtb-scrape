require 'singleton'

class PostUriStore
  include Singleton

  attr_accessor :post_urls, :index_urls, :index_urls
  def initialize
    @post_previews = {} # url, data
    @post_urls = []
    @index_urls = []
  end

  def enqueue_post(url, data = nil)
    @post_urls << url
    @post_previews[url] = data if data
  end

  def enqueue_index(url)
    @index_urls << url
  end

  def get_prev(url)
    @post_previews[url]
  end

  def empty?
    @index_urls.empty? && @post_urls.empty?
  end

  def take
    if !@index_urls.empty?
      [@index_urls.shift, :index] 
    else
      [@post_urls.shift, :post] 
    end
  end

  def all_urls
    queue = {}
    @index_urls.map { |url| queue[url] = :index }
    @post_urls.map  { |url| queue[url] = :post }
    queue
  end

  #class << self

    # needs to store
    #   index urls
    #   urls of new posts
    #   urls of changed posts
    #
    #   post previews??
end
