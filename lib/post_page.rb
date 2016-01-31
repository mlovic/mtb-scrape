module PostPage
  
  def all_attrs
    {
      description: description,
      images:      images,
      title:       title,
      uri:         new_uri
    }
  end

  #created at
    #attributes[:created_at] = page.root.css('abbr .DateTime').attr(:data-time)
  
  def description 
    root.css('.messageList blockquote').first
  end
  
  def images 
    root.css('li.image .filename a').map { |i| i['href'] }
  end

  def title
    at('.titleBar h1').text
  end

  def new_uri
    # what to do about this?
    self.uri.to_s
  end

      #attributes[:thread_id] = @current_thread # TODO make this better
      #attributes[:last_message_at] = @last_message_time

      #attributes = {
        #description: page.root.css('.messageList blockquote').first
      #}
      #attributes[:images] = page.root.css('li.image .filename a').map { |i| i['href'] }
      #attributes[:title] = page.at('.titleBar h1').text
      #attributes[:uri] = page.uri.to_s
      #attributes[:thread_id] = @current_thread # TODO make this better
      #attributes[:last_message_at] = @last_message_time
end
