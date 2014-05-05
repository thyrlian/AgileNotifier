require_relative 'tts'

module AgileNotifier
  class Judger
    class << self
      def on_fail(trackable, text, args)
        on_condition(trackable.failed?, text, args)
      end
      
      def on_unstable(trackable, text, args)
        on_condition(trackable.unstable?, text, args)
      end

      def on_pass(trackable, text, args)
        on_condition(trackable.passed?, text, args)
      end

      def on_fix(trackable, text, args)
        on_condition(trackable.fixed?, text, args)
      end

      def on_condition(condition, text, args)
        if condition
          TTS.speak(text, args)
          true
        else
          false
        end
      end
    end

    private_class_method :on_condition
  end
end