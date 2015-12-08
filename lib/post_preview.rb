require 'chronic'

module PostPreview

  def scrape
  end

  def sticky?
    self.attributes["class"].value.include?('sticky')
  end

  def thread_id
    self.attr(:id).split('-').last.to_i
  end

  def last_message_at
    unix_time = self.css('.lastPost .DateTime').attr('data-time').value.to_i
    return Time.at(unix_time).to_datetime
  end

  def title
    # fix the .last hack. Or make comment
    css('.title a').last.text.strip
  end

  def posted_at
    # error somteimes: undefined method 'value' for nil:nilClass
    date_element = css('.posterDate .DateTime')
    DateElementParser.parse(date_element)
  end

  def all_attrs
    {
      thread_id: thread_id,
      last_message_at: last_message_at,
      title: title,
      posted_at: posted_at
    }
  end

end
