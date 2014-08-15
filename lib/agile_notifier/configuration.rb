require_relative '../agile_notifier'

module AgileNotifier
  class Configuration
    def initialize(&blk)
      @current_module = Object.const_get(self.class.to_s.split('::').first)
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
      @ci = @current_module.const_get(ci_type).new(@ci_url, *@ci_jobs)
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
        @scm = @current_module.const_get(scm_type).new_enterprise_version(@scm_url)
      else
        @scm = @current_module.const_get(scm_type).new(@scm_url)
      end
      @scm_repos.each do |repo|
        @scm.add_repository(repo)
      end
      return @scm
    end

    def its_url(url)
      @its_url = url
    end

    def its_get(its_type)
      @its = @current_module.const_get(its_type).new(@its_url)
    end

    def speak(language)
      @language = language.to_s.downcase.intern
    end

    def play(voice)
      @voice = voice
    end

    def alert_on_fail
      alert(:blame, :fail)
    end
    
    def alert_on_unstable
      alert(:warn, :unstable)
    end

    def alert_on_fix
      alert(:praise, :fix)
    end

    def alert(composer_type, judger_type)
      args = Hash.new
      args[:language] = @language
      args[:voice] = @voice if @voice
      composer_type = composer_type.to_s.downcase
      judger_type = judger_type.to_s.downcase
      composer_method = "#{composer_type}_committer_of_a_commit".intern
      judger_method = "on_#{judger_type}".intern
      text = Composer.send(composer_method, repo: @scm.repository, revision: @ci.job.last_build.revision, language: @language)
      Judger.send(judger_method, @ci.job.last_build, text, args)
    end

    private_class_method :new
    private :alert
  end
end