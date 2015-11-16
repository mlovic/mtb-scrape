require 'forwardable'

class FmtbPost
  extend Forwardable
  attr_reader :preview

  def initialize(doc, agent, page)
    @preview = doc.extend PostPreview
    @agent = agent
    @page = page
  end

  def scrape
    get_post_page.all_attrs.merge @preview.all_attrs
  end

  private

    def get_post_page
      l = @preview.css('.PreviewTooltip').first # try css_at without the .first
      link = Mechanize::Page::Link.new(l, @agent, @page)
      post_page = link.click
      post_page.extend PostPage
    end
  
  # TODO keep post preview or not?
  
  def_delegators :@preview, :thread_id, :last_message_at, :title, :sticky?

  #def sticky?
    #@preview.attributes["class"].value.include?('sticky')
  #end

  #def thread_id
    #@preview.attr(:id).split('-').last.to_i
  #end

  #def last_message_at
    #unix_time = @preview.css('.lastPost .DateTime').attr('data-time').value.to_i
    #return Time.at(unix_time).to_datetime
  #end

  #def title
    ## fix the .last hack. Or make comment
    #@preview.css('.title a').last.text.strip
  #end
end
