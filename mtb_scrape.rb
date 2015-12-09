require_relative 'init'
#require_relative 'lib/post_parser'
#require_relative 'lib/foromtb'
#require_relative 'lib/post'
#require_relative 'lib/post_preview'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

module MtbScrape
  ROOT_DIR = '/home/marko/mtb_scrape'
end

require 'pp'
