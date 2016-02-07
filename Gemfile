source 'https://rubygems.org'

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'chronic'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

group :production do
  gem 'unicorn'
  gem 'rufus-scheduler'
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
  gem 'factory_girl'
end

