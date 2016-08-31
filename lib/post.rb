require 'active_record'
require_relative 'post_parser'

class Post < ActiveRecord::Base
  MIN_DESCRIPTION_LENGTH = 30

  validates :title, presence: true
  validates :thread_id, presence: true, uniqueness: true, unless: :is_old
  # is_old not being used, in favor of closed
  validates :posted_at, presence: true
  validates :uri, presence: true
  validates :last_message_at, presence: true

  has_one :bike

  default_scope { where(is_old: false) }
  #scope :only_latest, -> { where(is_old: false) }
  scope :not_parsed, -> { joins('LEFT OUTER JOIN bikes ON bikes.post_id = posts.id').where('post_id IS NULL') }

  scope :updated, -> { joins('LEFT OUTER JOIN bikes ON bikes.post_id = posts.id').where('posts.updated_at > bikes.updated_at ') }

  scope :active, -> { where(buyer: false, closed: false, deleted: false) }

  before_save do
    self.closed = (PostParser.sold?(self.title) || PostParser.closed?(self.title))
    self.buyer = PostParser.buyer?(self.title)
    self.deleted = true if self.description_no_html.gsub(/\s/, '').length < MIN_DESCRIPTION_LENGTH 
    # TODO how to deal with 'cerrado'
  end

  def self.oldest_last_message
    order('last_message_at ASC').first.last_message_at
    # TODO add index to last_message at. cv?
  end

  # make default?
  def description_no_html
    doc = Nokogiri::HTML(description)
    doc.xpath("//script").remove
    doc.text
  end

  def time_since_last_message
    Time.now - last_message_at
  end

  def time_since_posted
    Time.now - posted_at
  end

  #def active?
    #!buyer && !is_old
  #end

end
