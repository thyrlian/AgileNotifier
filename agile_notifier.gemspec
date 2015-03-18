# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require "agile_notifier"

Gem::Specification.new do |s|
  s.name        = 'agile_notifier'
  s.version     = AgileNotifier::VERSION
  s.license     = 'MIT'
  s.date        = '2015-03-18'
  s.summary     = %q{agile_notifier alerts you via making wonderful noises when your Continuous Integration status changes.}
  s.description = %q{agile_notifier alerts you via making wonderful noises when your Continuous Integration status changes.  It totally makes software development more agile and more fun.}
  s.authors     = ['Jing Li']
  s.email       = ['thyrlian@gmail.com']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage    = 'https://github.com/thyrlian/AgileNotifier'

  s.add_runtime_dependency('json', '~> 1.8.0', '>= 1.8.0')
  s.add_runtime_dependency('httparty', '~> 0.11.0', '>= 0.11.0')
  s.add_development_dependency('mocha', '~> 0.14.0', '>= 0.14.0')
end