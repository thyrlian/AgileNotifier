module AgileNotifier
  class SCM
    attr_accessor :url, :repositories

    def initialize(url)
      @url = url
      @repositories = []
    end

    def add_repository(repository)
      @repositories.push(repository)
    end

    class Repository
      attr_accessor :user, :repo, :url

      def initialize(args)
        @user = args[:user]
        @repo = args[:repo]
        @url = args[:url]
      end

      def get_commit(revision)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end

      def get_committer_of_a_commit(revision)
        raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
      end
    end
  end
end