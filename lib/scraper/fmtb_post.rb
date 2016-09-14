require 'forwardable'
require_relative 'post_preview'

class FmtbPost
  extend Forwardable
  include PostPreview
  attr_reader :preview

  def initialize(doc, page)
    @preview = doc.extend PostPreview
    @page = page
  end

  def_delegators :@preview, :thread_id, :last_message_at, :title, :sticky?, :url

end
