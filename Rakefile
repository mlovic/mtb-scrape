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



ActiveRecord::Base.logger = Logger.new('debug.log')

task :load_config do
  MIGRATIONS_DIR = 'db/migrations'
  @configuration = YAML::load(IO.read('db/database.yml'))
end

desc "Run migrations"
task :migrate => :load_config do
  puts 'running task'
  # Migrate dev db
  ActiveRecord::Base.establish_connection(@configuration['development'])
  ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  # Migrate test db
  ActiveRecord::Base.establish_connection(@configuration['test'])
  ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
task :rollback => :load_config do
  step = ENV['STEP'] ? ENV['STEP'].to_i : 1

  ActiveRecord::Base.establish_connection(@configuration['development'])
  ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step

  ActiveRecord::Base.establish_connection(@configuration['test'])
  ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step

end

task :copy_assets do
  FileUtils.cp_r 'assets/.', 'public', verbose: true
end
