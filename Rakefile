# Rakefile for bwiki

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

task :default => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new {|t| }
