require_relative 'tts'
require_relative 'composer'

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

      def on_limit(its, args)
        its.exceeds_limit?.each do |key, value|
          on_condition(value, "#{key} #{Composer.warn_wip_limit(args)}", args)
          sleep 1.5 if value
        end
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