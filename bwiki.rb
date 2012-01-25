require 'sinatra'
require 'haml'

helpers do
  def render_title(s = nil)
    "BWiki"
  end

  def render_branding
    # XXX get contents from config file
    ""
  end
end

get '/' do
  haml '<h1>BWiki Lives!</h1>'
end

get '/wiki.css' do
  send_file 'content/wiki.css', :type => :css
end
