#require_relative ''
require 'active_record'
require 'sqlite3'
require 'logger'
require 'yaml'

#task :default => :migrate

#ActiveRecord::Base.logger = Logger.new('debug.log')
#configuration = YAML::load(IO.read('db/database.yml'))
#ActiveRecord::Base.establish_connection(configuration['test'])

#desc "Run migrations"
#task :migrate do
  #ActiveRecord::Migrator.migrate('db/migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  ## Migrate dev db
  ## Migrate test db
#end



#ActiveRecord::Base.logger = Logger.new('debug.log')
configuration = YAML::load(IO.read('db/database.yml'))

desc "Run migrations"
task :migrate do
  # Migrate dev db
  ActiveRecord::Base.establish_connection(configuration['development'])
  ActiveRecord::Migrator.migrate('migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  # Migrate test db
  ActiveRecord::Base.establish_connection(configuration['test'])
  ActiveRecord::Migrator.migrate('migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end
