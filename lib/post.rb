require 'active_record'

class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :thread_id, presence: true

  # make default?
  def description_no_html
    Nokogiri::HTML(description).xpath("//text()").remove.to_s
  end
end
