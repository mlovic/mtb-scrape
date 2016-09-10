source 'https://rubygems.org'

gem 'sinatra'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'chronic'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'thor'
gem 'mechanize'
gem 'sqlite3'
gem 'concurrent-ruby', require: 'concurrent'

group :production do
  gem 'unicorn'
  gem 'rufus-scheduler'
  gem 'pg'
end

group :test, :development do
  gem 'thin'
  gem 'rspec'

  gem 'vcr'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'factory_girl'
  gem 'guard-rake'
  gem 'timecop'
end

