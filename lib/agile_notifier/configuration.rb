require_relative '../agile_notifier'

module AgileNotifier
  class Configuration
    def initialize(&blk)
      @current_module = Object.const_get(self.class.to_s.split('::').first)
      @its_args = Hash.new
      options = Commander.order(ARGV)
      @build_number = options[:build_number]
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
      @ci_job = job
    end

    def ci_get(ci_type)
      @ci = @current_module.const_get(ci_type).new(@ci_url, @ci_job)
    end
    
    def scm_url(url)
      @scm_url = url
    end
    
    def scm_repo(repo)
      @scm_repos ||= []
      @scm_repos.push(repo)
    end
    
    def scm_auth(auth)
      username = auth.fetch(:username, nil)
      password = auth.fetch(:password, nil)
      token = auth.fetch(:token, nil)
      @scm_authentication = username && password ? {:basic_auth => {:username => username, :password => password}} : nil
      @scm_authentication = {:Authorization => "token #{token}"} if token
    end
    
    def scm_get(scm_type, args = {})
      enterprise = args.fetch(:enterprise, false)      
      params = [@scm_url]
      params.push(@scm_authentication) if @scm_authentication
      if enterprise
        @scm = @current_module.const_get(scm_type).new_enterprise_version(*params)
      else
        @scm = @current_module.const_get(scm_type).new(*params)
      end
      @scm_repos.each do |repo|
        @scm.add_repository(repo)
      end
      return @scm
    end

    def its_url(url)
      @its_args[:url] = url
    end

    def its_auth(username, password)
      @its_args.merge!(:username => username, :password => password)
    end

    def its_get(its_type)
      @its = @current_module.const_get(its_type).new(@its_args)
    end

    def its_set_wip(project, query, limit)
      @its.set_limit(project, query, limit)
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
      composer_type = composer_type.to_s.downcase
      judger_type = judger_type.to_s.downcase
      composer_method = "#{composer_type}_committer_of_a_commit".intern
      judger_method = "on_#{judger_type}".intern
      build = @build_number.nil? ? @ci.job.current_build : @ci.job.get_specific_build(@build_number)
      text = Composer.send(composer_method, repo: @scm.repository, revision: build.revision, language: @language)
      Judger.send(judger_method, build, text, organize_args)
    end

    def alert_on_wip
      Judger.on_limit(@its, organize_args)
    end

    def organize_args
      args = Hash.new
      args[:language] = @language
      args[:voice] = @voice if @voice
      args
    end

    private_class_method :new
    private :alert, :organize_args
  end
end