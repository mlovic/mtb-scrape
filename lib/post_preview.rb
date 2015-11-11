module PostPreview

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
    n.css('.title').text.strip
  end

end
