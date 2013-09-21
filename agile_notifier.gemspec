# encoding: utf-8

require File.expand_path('./lib/agile_notifier', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'agile_notifier'
  s.version     = AgileNotifier::VERSION
  s.date        = '2013-05-22'
  s.summary     = %q{agile_notifier alerts you via making wonderful noises}
  s.description = %q{agile_notifier alerts you via making wonderful noises, make software development more fun}
  s.authors     = 'Jing Li'
  s.email       = 'thyrlian@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/agile_notifier'
end