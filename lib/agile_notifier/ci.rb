module AgileNotifier
  class CI
    attr_accessor :jobs

    def initialize(url)
      @url = url
      @jobs = get_all_jobs
    end

    def get_all_jobs
      raise "Abstract method [#{__method__}] is called, please implement"
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
        raise "Abstract method [#{__method__}] is called, please implement"
      end

      class Build
        attr_accessor :number, :url, :result #, :time, :revision

        def initialize(number, url)
          @number = number
          @url = url
          @result = get_result
        end

        def get_result
          raise "Abstract method [#{__method__}] is called, please implement"
        end
      end
    end
  end
end