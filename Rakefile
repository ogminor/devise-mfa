#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Run Devise tests for all ORMs.'
task :tests do
  Dir[File.join(File.dirname(__FILE__), 'test', 'orm', '*.rb')].each do |file|
    orm = File.basename(file).split(".").first
    system "rake test DEVISE_ORM=#{orm}"
  end
end

desc 'Default: run tests for all ORMs.'
task :default => :tests
