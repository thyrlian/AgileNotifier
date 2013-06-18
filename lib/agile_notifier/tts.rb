module AgileNotifier
  class TTS
    class << self
      def speak(text)
        speak_via('osx_speech', text)
      end

      def speak_via(service, text)
        call_service(service, text)
      end

      def call_service(service, text)
        send(service.intern, text)
      end

      def encode_www_form_and_remove_punctuation(text)
        text.gsub(/(\W\s+)|(\W)|(\s+)/, '+').gsub(/\++$/, '')
      end

      def osx_speech(text)
        fork { exec "say #{text}"}
      end

      def tts_api(text)
        api = 'http://tts-api.com/tts.mp3?q='
        api + encode_www_form_and_remove_punctuation(text)
      end
    end

    private_class_method :new, :call_service, :encode_www_form_and_remove_punctuation
  end
end