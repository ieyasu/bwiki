$spec_dir = File.dirname(__FILE__)
require $spec_dir + '/../bwiki'
require 'rack/test'

set :environment, :test

describe 'BWiki' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:all) do
    Dir.chdir($spec_dir)
    `cp -r ../template content`
  end

  after(:all) do
    `rm -r content`
    Dir.chdir($spec_dir + '/..')
  end

  it "redirects / to start page" do
    get '/'
    follow_redirect!

    last_request.url.should =~ %r!/StartPage!
    last_response.ok?.should be_true
  end

  it "sends /wiki.css" do
    get '/wiki.css'
    last_response.ok?.should be_true
  end

  it "sends images" do
    img = File.basename Dir['content/images/*.*'].first
    get "/images/#{img}"
    last_response.ok?.should be_true
  end

  it "sends wiki pages" do
    get "/StartPage"
    last_response.ok?.should be_true
    b = last_response.body
    i = b.index(/<div[^>]+id=['"]content/i)
    i.should_not be_nil
    j = b.index(%r!</div!i, i)
    j.should_not be_nil
    (j - i).should be > 4
  end
end
