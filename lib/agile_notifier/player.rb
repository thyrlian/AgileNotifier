module AgileNotifier
  class Player
    class << self
      def play_on_osx(file)
        system("afplay #{file}")
      end
    end

    private_class_method :new
  end
end