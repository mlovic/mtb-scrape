require 'thor'
require 'pp'

$LOAD_PATH << '.'

require 'mtb_scrape'

ActiveRecord::Base.logger = Logger.new('db/debug.log')
configuration = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

#module MtbScrape 
  class MtbCli < Thor
    package_name "Mtb"

    desc 'scrape NUM_PAGES', 'scrapes N number of pages from foromtb'
    method_option :offset, type: :numeric
    def scrape(num_pages)
      offset = options[:offset]
      MtbScrape::fmtb_scrape(num_pages.to_i, start_page: offset)
    end

    desc 'parse_posts', 'parses all posts in db and saves them in bikes table'
    def parse_posts
      MtbScrape.parse_virgin_posts
    end

    desc 'reparse', 'reparses posts for all bikes in DB'
    method_option :dry, type: :boolean
    method_option :id, type: :numeric
    method_option :count, type: :numeric, aliases: '-c'
    def reparse
      BikeUpdater.new.update_bikes(count: options[:count], 
                                   id: options[:id], 
                                   dry_run: options[:dry])
    end

    desc 'update', 'scrapes foromtb and updates post information and bikes table'
    def update
      MtbScrape::update
    end

    desc 'new_brand NAME', 'ddssdfsdf'
    def new_brand(name)
      say 'Created new brand' if MtbScrape::create_new_brand(name)
    end

    desc 'add_brand NAME', 'add new brand to the DB'
    def add_brand(name)
      Brand.create(name: name, confirmation_status: 1)
    end

  end
#end
