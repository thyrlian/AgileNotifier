require_relative '../agile_notifier'

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

    def speak(language)
      @language = language.to_s.downcase.intern
    end

    def play(voice)
      @voice = voice
    end

    def alert_on_fail
      text = Composer.blame_committer_of_a_commit(repo: @scm.repository, revision: @ci.job.last_build.revision, language: @language)
      args = Hash.new
      args[:language] = @language if @language
      args[:voice] = @voice if @voice
      Judger.on_fail(@ci.job.last_build, text, args)
    end

    private_class_method :new
  end
end