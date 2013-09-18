module AgileNotifier
  class OperatingSystem
    TYPE = {
        lin: 'linux',
        mac: 'osx',
        win: 'windows',
        unknown: 'UNKNOWN'
    }

    class << self
      def is_linux?
        match_os(/linux/)
      end

      def is_mac?
        match_os(/darwin/)
      end

      def is_windows?
        match_os(/mswin|mingw|cygwin|bccwin|wince|emx/)
      end

      def match_os(regex)
        !!RUBY_PLATFORM.match(regex)
      end

      def what
        return TYPE[:lin] if is_linux?
        return TYPE[:mac] if is_mac?
        return TYPE[:win] if is_windows?
        return TYPE[:unknown]
      end
    end

    private_class_method :new, :match_os
  end
end