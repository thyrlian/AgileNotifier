require_relative 'tts'

module AgileNotifier
  class Judger
    class << self
      def on_fail(trackable, text)
        on_condition(trackable.failed?, text)
      end

      def on_pass(trackable, text)
        on_condition(trackable.passed?, text)
      end

      def on_fix(trackable, text)
        on_condition(trackable.fixed?, text)
      end

      def on_condition(condition, text)
        TTS.speak(text) if condition
      end
    end

    private_class_method :on_condition
  end
end