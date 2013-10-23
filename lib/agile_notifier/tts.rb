require 'uri'
require 'open-uri'
require_relative 'operating_system'
require_relative 'player'

module AgileNotifier
  class TTS
    class << self
      def speak(text, args)
        os_type = get_os_type
        service = "speak_on_#{os_type}"
        language = args[:language]
        voice = args[:voice]
        Service.send(service.intern, text, language, voice)
      end

      def get_os_type
        OperatingSystem.what
      end
    end

    class Service
      @@temp_file = File.dirname(__FILE__) + '/temp_tts'

      class << self
        def download_file(url, file = @@temp_file)
          open(url) do |remote_file|
            data = remote_file.read
            File.open(file, 'wb') do |local_file|
              local_file.write(data)
            end
          end
        end

        def remove_file(file = @@temp_file)
          File.delete(file)
        end

        def play(url)
          download_file(url)
          os_type = get_os_type
          player = "play_on_#{os_type}"
          Player.send(player.intern, @@temp_file)
          remove_file
        end

        def replace_punctuation_by_space(text)
          text.gsub(/[[:punct:]](\s+)*/, ' ').gsub(/\s$/, '')
        end

        def encode_www_form(text)
          URI.encode_www_form('' => text)[1..-1]
        end

        def encode_www_form_and_remove_punctuation(text)
          encode_www_form(replace_punctuation_by_space(text))
        end

        def speak_on_linux(text, language, voice = nil)
          # TODO: should check service availability first, if not raise exception
          mary_tts(text, language)
        end

        def speak_on_osx(text, language, voice)
          if voice
            unless system(osx_speech(voice, text))
              raise("No available voice found, please check if you have downloaded voice [#{voice}] in System Preferences -> Speech")
            end
          else
            list_of_available_voices = `say -v '?'`.split("\n")
            voices = list_of_available_voices.inject({}) do |collection, record|
              matched_results = record.match(/^(\w+).*?(\w{2})_/)
              available_language = matched_results[2].downcase.intern
              available_voice = matched_results[1]
              if collection.has_key?(available_language)
                collection[available_language] << available_voice
              else
                collection[available_language] = [available_voice]
              end
              collection
            end
            system(osx_speech(voices[language].first, text))
          end
        end

        def speak_on_windows(text, language, voice = nil)
          raise(NotImplementedError, "Method [#{__method__}] is empty, please implement", caller)
        end

        def osx_speech(voice, text)
          "say -v #{voice} #{text} > /dev/null 2>&1"
        end

        def tts_api(text)
          url = 'http://tts-api.com/tts.mp3?q='
          play(url + encode_www_form_and_remove_punctuation(text))
        end

        def mary_tts(text, language)
          url = 'http://mary.dfki.de:59125/'
          text = encode_www_form_and_remove_punctuation(text)
          audio_format = 'WAVE_FILE'
          play(url + "process?INPUT_TEXT=#{text}&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&LOCALE=#{language}&AUDIO=#{audio_format}")
        end
      end

      private_class_method :download_file, :remove_file, :play, :replace_punctuation_by_space, :encode_www_form, :encode_www_form_and_remove_punctuation, :osx_speech
    end

    private_class_method :new, :get_os_type
  end
end