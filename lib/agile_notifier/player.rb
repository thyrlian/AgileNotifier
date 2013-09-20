module AgileNotifier
  class Player
    class << self
      def play_on_linux(file)
        raise(NotImplementedError, "Method [#{__method__}] is empty, please implement", caller)
      end

      def play_on_osx(file)
        system("afplay #{file}")
      end

      def play_on_windows(file)
        raise(NotImplementedError, "Method [#{__method__}] is empty, please implement", caller)
      end
    end

    private_class_method :new
  end
end