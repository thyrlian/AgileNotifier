module AgileNotifier
  class Player
    class << self
      def play_on_osx(file)
        fork { exec 'afplay', file }
      end
    end

    private_class_method :new
  end
end