require 'active_record'

class Post < ActiveRecord::Base

  # make default?
  def description_no_html
    Nokogiri::HTML(description).xpath("//text()").remove.to_s
  end
end
