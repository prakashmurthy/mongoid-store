require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

task :default => :test
Rake::TestTask.new do |t|
  t.libs = %w(test lib)
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end
