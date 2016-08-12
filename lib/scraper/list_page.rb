require_relative 'fmtb_post'

module ListPage
  #attr_accessor :agent

  def posts(with_sticky: false)
    #raise 'agent nil!!' unless @agent
    ps = root.css('.discussionListItem').map do |n| 
      FmtbPost.new n.extend(PostPreview), self
    end
    ps.reject(&:sticky?) unless with_sticky
  end


end
