source 'https://rubygems.org'

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'chronic'

group :production do
  gem 'unicorn'
end

group :test, :development do
  gem 'thin'
  gem 'sqlite3'
  gem 'rspec'

  gem 'mechanize'
  gem 'vcr'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'guard-rspec'
end

