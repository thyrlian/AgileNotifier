require 'optparse'

module AgileNotifier
  class Commander
    class << self
      def order(args)
        options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: #{caller[-1].match(/\S+\.rb/)} [options]"
          
          opts.on('-b', '--build-number [BUILD_NUMBER]', OptionParser::DecimalInteger, 'Trigger by specific build') do |build_number|
            options[:build_number] = build_number
          end
        end.parse!
        options
      end
    end
    
    private_class_method :new
  end
end