class TTS
  class << self
    def speak(text)
      speak_via('tts_api', text)
    end

    def speak_via(service, text)
      call_service(service, encode_www_form_and_remove_punctuation(text))
    end

    def encode_www_form_and_remove_punctuation(text)
      text.gsub(/(\W\s+)|(\W)|(\s+)/, '+').gsub(/\++$/, '')
    end

    def call_service(service, text)
      send(service.intern, text)
    end

    def tts_api(text)
      api = 'http://tts-api.com/tts.mp3?q='
      api + text
    end
  end

  private_class_method :encode_www_form_and_remove_punctuation, :call_service
end