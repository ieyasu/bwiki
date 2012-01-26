require 'sinatra'
require 'haml'

helpers do
  def render_title(s = nil)
    "BWiki"
  end

  def render_branding
    File.open("content/branding.html") do |fin|
      fin.read
    end
  end
end

get '/' do
  haml '<h1>BWiki Lives!</h1>'
end

get '/wiki.css' do
  send_file 'content/wiki.css', :type => :css
end

get '/images/:name' do
  path = 'content/images/' + params[:name]
  if params[:name].index('..') || params[:name].index('/')
    400
  elsif File.exist?(path)
    send_file path
  else
    raise Sinatra::NotFound
  end
end
