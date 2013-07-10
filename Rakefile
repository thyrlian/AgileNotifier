$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), *%w[lib])))
require 'agile_notifier'

task :default => :test

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end