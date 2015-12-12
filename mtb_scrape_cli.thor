require 'thor'

$LOAD_PATH << '.'

require 'mtb_scrape'

#module MtbScrape 
  class MtbCli < Thor
    package_name "Mtb"

    desc 'scrape NUM_PAGES', 'scrapes N number of pages from foromtb'
    def scrape(num_pages)
      MtbScrape::fmtb_scrape(num_pages.to_i)
    end

    desc 'parse_posts', 'parses all posts in db and saves them in bikes table'
    def parse_posts
      # posts.each
      #   attrs = parse_post
      #   bikes.new attrs if bikes doesnt exist
      #
      #   with logging
      #
      #
      #
      #
      #
    end

  end
#end
