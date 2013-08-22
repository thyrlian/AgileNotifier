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
      @ci_url = url
    end

    def ci_job(job)
      @ci_jobs ||= []
      @ci_jobs.push(job)
    end

    def ci_get(ci_type)
      @ci = ci_type.new(@ci_url, *@ci_jobs)
    end
    
    def scm_url(url)
      @scm_url = url
    end
    
    def scm_repo(repo)
      @scm_repos ||= []
      @scm_repos.push(repo)
    end
    
    def scm_get(scm_type, args = {})
      enterprise = args.fetch(:enterprise, false)
      if enterprise
        @scm = scm_type.new_enterprise_version(@scm_url)
      else
        @scm = scm_type.new(@scm_url)
      end
      @scm_repos.each do |repo|
        @scm.add_repository(repo)
      end
      return @scm
    end

    private_class_method :new
  end
end