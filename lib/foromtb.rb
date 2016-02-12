require 'mechanize'
require 'sqlite3'
require 'pp'
require 'active_record'
require 'date'

require_relative 'post'
require_relative 'post_preview'
require_relative 'post_page'
require_relative 'list_page'
require_relative 'date_element_parser'

class ForoMtb

  FOROMTB_URI = 'http://www.foromtb.com/forums/btt-con-suspensi%C3%B3n-trasera.60/'

  def initialize
    mech_logger = Logger.new('logs/mechanize.log')
    mech_logger.level = Logger::INFO
    Mechanize.log = mech_logger
  end

  def visit_page(num)
    @agent = Mechanize.new
    page = @agent.get URI.join(FOROMTB_URI, "page-#{num}")
    puts "retrieved main page...  #{page.header["content-length"]}"
    page.extend ListPage
    page.agent = @agent
    return page
  end

end

