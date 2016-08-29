require 'active_record'

class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :thread_id, presence: true, uniqueness: true, unless: :is_old
  # is_old not being used, in favor of closed
  validates :posted_at, presence: true
  validates :uri, presence: true
  validates :last_message_at, presence: true

  has_one :bike

  default_scope { where(is_old: false) }
  #scope :only_latest, -> { where(is_old: false) }
  scope :not_parsed, -> { joins('LEFT OUTER JOIN bikes ON bikes.post_id = posts.id').where('post_id IS NULL').where(buyer: false) }

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

end
