$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), *%w[.. lib agile_notifier])))
require 'agile_notifier'
require 'test/unit'
require 'mocha/setup'

include AgileNotifier