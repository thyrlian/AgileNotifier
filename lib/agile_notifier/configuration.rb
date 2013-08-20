module AgileNotifier
  class Configuration
    def initialize(&blk)
      instance_eval(&blk)
    end

    class << self
      def set(&blk)
        new(&blk)
      end
    end

    def ci_url(url)
      @url = url
      @jobs = []
    end

    def ci_job(job)
      @jobs.push(job)
    end

    def ci_get(ci_type)
      ci = ci_type.new(@url, *@jobs)
    end

    private_class_method :new
  end
end