require 'active_record'

module MtbScrape
  ActiveRecord::Base.logger = Logger.new('db/debug.log')
  configuration = YAML::load(IO.read('db/database.yml'))
  ActiveRecord::Base.establish_connection(configuration['development'])
end
