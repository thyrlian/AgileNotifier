require_relative 'servable'

module AgileNotifier
  class CI
    include Servable
    alias_method :original_is_available?, :is_available?

    attr_accessor :jobs

    def initialize(url)
      @url = url
      @jobs = get_all_jobs
    end

    def is_available?
      original_is_available?(@url)
    end

    def get_all_jobs
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end

    class Job
      attr_accessor :name, :url
      attr_reader :last_build

      def initialize(name, url)
        @name = name
        @url = url
        @last_build = get_last_build
      end

      def get_last_build
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end

      class Build
        attr_accessor :number, :url, :result #, :time, :revision

        def initialize(number, url)
          @number = number
          @url = url
          @result = get_result
        end

        def get_result
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end
      end
    end
  end
end