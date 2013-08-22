$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), *%w[lib])))
require 'agile_notifier'

task :default => :test

require 'rake/testtask'
desc 'Run Unit Test'
Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files = FileList['test/test*.rb']
  test.verbose = true
end