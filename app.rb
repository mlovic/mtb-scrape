require 'sinatra'

require_relative 'lib/post'
require_relative 'lib/post_parser'

get '/' do
  @posts = Post.all
  erb :index
end
