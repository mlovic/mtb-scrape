#require_relative ''
require 'active_record'
require 'sqlite3'
require 'logger'

#task :default => :migrate

ActiveRecord::Base.logger = Logger.new('debug.log')
configuration = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

desc "Run migrations"
task :migrate do
  ActiveRecord::Migrator.migrate('migrations', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end
