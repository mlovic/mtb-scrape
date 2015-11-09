require 'logger'
require 'active_record'
require 'sqlite3'
require 'mechanize'

require_relative 'lib/foromtb'
require_relative 'lib/post'

ActiveRecord::Base.logger = Logger.new('db/debug.log')
configuration = YAML::load(IO.read('db/database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

puts 'Posts:'
Post.all.each do |post|
  puts post.title
end

fmtb = ForoMtb.new
fmtb.scrape_first_page(4)


# TODO open dataset: mtb index. all bikes: model, year, travel, msrp
