require_relative 'servable'
require_relative 'trackable'

module AgileNotifier
  class CI
    include Servable
    alias_method :original_is_available?, :is_available?

    attr_accessor :jobs

    def initialize(url, *jobs)
      @url = url
      jobs.empty? ? @jobs = get_all_jobs : @jobs = jobs
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

      def update_last_build
        @last_build = get_last_build
      end

      class Build
        include Trackable

        attr_accessor :number, :url, :result, :revision

        def initialize(number, url)
          @number = number
          @url = url
          @result = get_result
          @revision = get_revision
        end

        def get_result
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_revision
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end
      end
    end
  end
end