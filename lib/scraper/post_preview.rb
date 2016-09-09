require 'chronic'
require_relative 'date_element_parser'

module PostPreview

  def url
    css('.title a').last['href']
  end

  def sticky?
    self.attributes["class"].value.include?('sticky')
  end

  def username
    attr('data-author')
  end

  def visits
    at_css('.stats .minor dd').text.to_i
  end

  def thread_id
    self.attr(:id).split('-').last.to_i
  end

  def last_message_at
    date_element = css('.lastPost .DateTime')
    DateElementParser.parse(date_element)
  end

  def title
    css('.title a').last.text.strip 
  end

  def posted_at
    date_element = css('.posterDate .DateTime')
    DateElementParser.parse(date_element)
  end

  def all_attrs
    {
      thread_id: thread_id,
      last_message_at: last_message_at,
      title: title,
      posted_at: posted_at,
      username: username, 
      visits: visits
    }
  end

end
