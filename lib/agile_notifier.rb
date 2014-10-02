Dir[(File.expand_path(File.dirname(__FILE__)) + "/agile_notifier/*.rb")].each { |file| require file }

module AgileNotifier
  VERSION = '2.1.2'
end