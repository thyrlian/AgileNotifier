module AgileNotifier
  class OperatingSystem
    class << self
      def is_mac?
        match_os(/darwin/)
      end

      def is_linux?
        match_os(/linux/)
      end

      def is_windows?
        match_os(/mswin|mingw|cygwin|bccwin|wince|emx/)
      end

      def match_os(regex)
        !!RUBY_PLATFORM.match(regex)
      end
    end

    private_class_method :new, :match_os
  end
end