require 'scraper/post_preview'

module ListPage

  def posts(with_sticky: false)
    ps = root.css('.discussionListItem').map do |n| 
      n.extend(PostPreview)
    end
    with_sticky ? ps : ps.reject(&:sticky?)
  end
end
