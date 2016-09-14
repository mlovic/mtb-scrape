require 'active_record'
require 'sqlite3'
require 'logger'
require 'yaml'

ActiveRecord::Base.logger = Logger.new('debug.log')
MIGRATIONS_DIR = 'db/migrations'

def migrate_db(db_config)
  ActiveRecord::Base.establish_connection(db_config)
  ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

directory "public"

task :build do
  puts "Migrating database..."
  Rake::Task['migrate'].invoke
  puts "Copying assets to public/ ..."
  Rake::Task['copy_assets'].invoke
  puts "Installing front-end dependencies..."
  sh 'bower install'
end

task :load_config do
  @configuration = YAML::load(IO.read('db/database.yml'))
end

desc "Run migrations"
task :migrate => :load_config do
  env = ENV['RACK_ENV']
  case env
  when 'production', 'development', 'test'
    migrate_db(@configuration[env])
  when nil
    migrate_db(@configuration['development'])
    migrate_db(@configuration['test'])
  else
    raise "Unknown environment: #{env}"
  end
end

desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
task :rollback => :load_config do
  step = ENV['STEP'] ? ENV['STEP'].to_i : 1

  ActiveRecord::Base.establish_connection(@configuration['development'])
  ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step

  ActiveRecord::Base.establish_connection(@configuration['test'])
  ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step

end

task :copy_assets => :public do
  FileUtils.cp_r 'assets/.', 'public', verbose: true
end
