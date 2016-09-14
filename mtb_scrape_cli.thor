require 'thor'
require 'pp'

$LOAD_PATH << '.'

require 'mtb_scrape'

ActiveRecord::Base.logger = Logger.new('db/debug.log')
configuration = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

class MtbCli < Thor
  package_name "Mtb"

  desc 'scrape NUM_PAGES', 'Scrape the n first pages from foromtb'
  method_option :offset, type: :numeric
  def scrape(num_pages)
    offset = options[:offset]
    MtbScrape::fmtb_scrape(num_pages.to_i, start_page: offset)
  end

  desc 'parse_posts', 'Build or update bikes from all new or updated posts'
  def parse_posts
    MtbScrape.parse_new_or_updated_posts
  end

  desc 'reparse', 'Rebuild bikes from their post data'
  method_option :dry, type: :boolean
  method_option :id, type: :numeric
  method_option :count, type: :numeric, aliases: '-c'
  def reparse
    BikeUpdater.new.update_bikes(count: options[:count], 
                                 id: options[:id], 
                                 dry_run: options[:dry])
  end

  desc 'update', 'Scrape last 5 pages of foromtb and update bike information'
  def update
    MtbScrape::update
  end

  desc 'add_brand NAME', 'Add new brand to the DB'
  def add_brand(name)
    Brand.create!(name: name, confirmation_status: 1)
  end

end
