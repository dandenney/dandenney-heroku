require 'sinatra'
require 'haml'
require 'rdiscount'
require 'sass'


# Helpers

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end


# Routing

get '/' do
  haml :index
end

post '/process' do
  ugly = params[:options][:ugly] == "false" ? false : true
  h Haml::Engine.new(params[:haml], {ugly: ugly}).render
end


# Sassify Stylesheets

get '/stylesheets/style.css' do
  content_type 'text/css', charset: 'utf-8'
  scss :'/stylesheets/style'
end

get '/stylesheets/deck.core.css' do
  content_type 'text/css', charset: 'utf-8'
  scss :'/stylesheets/deck.core'
end


# Errors

not_found do  
  halt 404, haml(:error)
end