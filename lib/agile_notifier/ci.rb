require_relative 'servable'
require_relative 'trackable'

module AgileNotifier
  class CI
    include Servable
    alias_method :original_is_available?, :is_available?

    attr_accessor :job

    def is_available?
      original_is_available?(@url)
    end

    def get_all_jobs
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end

    class Job
      attr_accessor :name, :url
      attr_reader :current_build

      def initialize(name, url, build_number = nil)
        @name = name
        @url = url
        @current_build = build_number.nil? ? get_last_build : get_specific_build(build_number.to_i)
      end
      
      def get_specific_build(build_number)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end

      def get_last_build
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
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
        
        def is_building?
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_result
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_revision
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_branch
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_previous_build
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end

        def get_previous_result
          raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
        end
      end
    end
  end
end