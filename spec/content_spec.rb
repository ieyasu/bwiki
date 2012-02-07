$spec_dir = File.dirname(__FILE__)
require 'bwiki-content'
include BWiki

describe "Content Manager" do
  before(:all) do
    Dir.chdir($spec_dir)
  end

  after(:all) do
    `rm -rf content`
    Dir.chdir($spec_dir + '/..')
  end

  it "creates an initial repository" do
    create_content_repository

    File.directory?('content').should be_true
    File.directory?('content/pages').should be_true
    File.directory?('content/images').should be_true
    File.exist?('content/branding.html').should be_true
    File.exist?('content/wiki.css').should be_true
    File.exist?('content/pages/StartPage').should be_true
    `cd content; git status`
    $?.to_i.should == 0
  end
end
