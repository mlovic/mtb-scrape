require 'active_record'

class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :thread_id, presence: true
  validates :posted_at, presence: true
  validates :uri, presence: true
  validates :last_message_at, presence: true

  # make default?
  def description_no_html
    Nokogiri::HTML(description).xpath("//text()").remove.to_s
  end

end
