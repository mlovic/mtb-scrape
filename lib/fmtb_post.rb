require 'forwardable'
require_relative 'post_preview'

class FmtbPost
  extend Forwardable
  include PostPreview
  attr_reader :preview

  def initialize(doc, agent, page)
    @preview = doc.extend PostPreview
    @agent = agent
    @page = page
  end

  def scrape
    get_post_page.all_attrs.merge @preview.all_attrs
  end

  #private

    def get_post_page
      l = @preview.css('.PreviewTooltip').first # try css_at without the .first
      link = Mechanize::Page::Link.new(l, @agent, @page)
      post_page = link.click
      post_page.extend PostPage
    end
  
  # TODO keep post preview or not?
  
  def_delegators :@preview, :thread_id, :last_message_at, :title, :sticky?, :url

end
