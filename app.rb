require 'compass'
require 'sinatra'
require 'haml'
require 'rdiscount'
require 'sass'
require 'newrelic_rpm'


# Helpers

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

configure do
  set :haml, {:format => :html5, :escape_html => true}
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

# Makes SCSS compile to CSS, need to repeat for folders

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/#{params[:name]}" ) 
end

get '/stylesheets/posts/front-end-dev/name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/posts/front-end-dev/#{params[:name]}" ) 
end

# Routing

get '/' do
  haml :index
end

get '/posts' do
  haml :"posts/index"
end

  # General Posts

  get '/posts/general/growing-with-envy' do
    haml :"posts/general/growing-with-envy"
  end

  get '/posts/general/rebuilding' do
    haml :"posts/general/rebuilding"
  end

  get '/posts/general/fluid' do
    haml :"posts/general/fluid"
  end

  # Front-End Dev Posts

  get '/posts/front-end-dev/playing-with-css-hat' do
    haml :"posts/front-end-dev/playing-with-css-hat"
  end

  get '/posts/front-end-dev/mondays-rock' do
    haml :"posts/front-end-dev/mondays-rock"
  end

  get '/posts/front-end-dev/production-vs-shipping' do
    haml :"posts/front-end-dev/production-vs-shipping"
  end

  get '/posts/front-end-dev/HTML-but-with-an-a-and-less-code' do
    haml :"posts/front-end-dev/HTML-but-with-an-a-and-less-code"
  end

  get '/posts/front-end-dev/a-sass-noob-using-math-for-flexible-widths' do
    haml :"posts/front-end-dev/a-sass-noob-using-math-for-flexible-widths"
  end

  get '/posts/front-end-dev/sass-compass-pairing-with-michael-parenteau' do
    haml :"posts/front-end-dev/sass-compass-pairing-with-michael-parenteau"
  end

# Errors

not_found do  
  halt 404, haml(:error)
end

# Haml Partials

def partial(template, *args)
  options = args.last.is_a?(Hash) ? args.pop : { }
  options.merge!(:layout => false)
  if collection = options.delete(:collection) then
      haml_concat(collection.inject([]) do |buffer, member|
        buffer << haml(template, options.merge(
                                :layout => false,
                                :locals => {template.to_sym => member}
                              )
                   )
    end.join("\n"))
  else
    haml_concat(haml(template, options))
  end
end