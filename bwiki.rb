require 'sinatra'
require 'haml'
require 'bwiki-format'

helpers do
  def render_title(s = nil)
    if @page
      "#{@page} - BWiki"
    else
      "BWiki"
    end
  end

  def render_branding
    File.open("content/branding.html") do |fin|
      fin.read
    end
  end
end

get '/' do
  redirect to('/StartPage')
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

get BWiki::PAGE_URL do
  @page = params[:captures].first
  @path = "content/pages/#{@page}"
  if File.exist?(@path)
    haml :page
  else
    raise Sinatra::NotFound
  end
end
