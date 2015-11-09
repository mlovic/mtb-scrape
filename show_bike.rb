#!/usr/bin/env ruby
#
require 'nokogiri'

require_relative 'post'

ActiveRecord::Base.logger = Logger.new('debug.log')
configuration = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

post = Post.find(ARGV[0])
puts post.description
puts '------------------------------------'
puts post.description_no_html.strip
puts '------------------------------------'
p post.title
