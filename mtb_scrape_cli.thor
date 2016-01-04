require 'thor'
require 'pp'

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
    end

    desc 'reset_bikes', 'deletes all bikes recreates them after parsing all posts'
    def reset_bikes
      MtbScrape::reset_bikes
    end

    desc 'update', 'scrapes foromtb and updates post information and bikes table'
    def update
      MtbScrape::update
    end

    desc 'new_brand NAME', 'ddssdfsdf'
    def new_brand(name)
      say 'Created new brand' if MtbScrape::create_new_brand(name)
    end

  end
#end
