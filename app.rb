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

configure :production do
  require 'newrelic_rpm'
end

configure do
  set :haml, {:format => :html5}
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

# Makes SCSS compile to CSS, need to repeat for folders

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheets/#{params[:name]}" ) 
end

get '/stylesheets/posts/front-end-dev/name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/posts/front-end-dev/#{params[:name]}" ) 
end

get '/stylesheets/posts/conferences/name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/posts/front-end-dev/#{params[:name]}" ) 
end

# Routing

get '/' do
  haml :index
end

get '/work' do
  haml :work
end

get '/invitations/dave-rupert' do
  haml :"invitations/dave-rupert"
end

get '/invitations/doug-neiner' do
  haml :"invitations/doug-neiner"
end

get '/invitations/cameron-moll' do
  haml :"invitations/cameron-moll"
end

get '/invitations/jenn-lukas' do
  haml :"invitations/jenn-lukas"
end

get '/invitations/allison-wagner' do
  haml :"invitations/allison-wagner"
end

get '/invitations/chris-coyier' do
  haml :"invitations/chris-coyier"
end

get '/invitations/michael-parenteau' do
  haml :"invitations/michael-parenteau"
end

get '/research' do
  haml :research
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

  get '/posts/front-end-dev/border-image-bits' do
    haml :"posts/front-end-dev/border-image-bits"
  end
  
  get '/posts/front-end-dev/im-down-with-svg' do
    haml :"posts/front-end-dev/im-down-with-svg"
  end

  get '/posts/front-end-dev/see-nick-preprocess' do
    haml :"posts/front-end-dev/see-nick-preprocess"
  end

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

# Conferences Posts

  get '/posts/conferences/rebuild-conference-2012' do
    haml :"posts/conferences/rebuild-conference-2012"
  end

  get '/posts/conferences/future-of-front-end-conf' do
    haml :"posts/conferences/future-of-front-end-conf"
  end
  
  get '/posts/conferences/circles-conference-2012' do
    haml :"posts/conferences/circles-conference-2012"
  end

get "/thoughts/" do
  haml :"thoughts/index"
end

get "/thoughts/i-love-kippt" do
  haml :"thoughts/i-love-kippt"
end

get "/thoughts/execution-is-all-that-matters" do
  haml :"/thoughts/execution-is-all-that-matters"
end

get "/thoughts/attitude-reflect-leadership" do
  haml :"/thoughts/attitude-reflect-leadership"
end

error 404 do
  erb :fof
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