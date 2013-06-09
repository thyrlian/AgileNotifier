module AgileNotifier
  class ITS
    def initialize(url)
      @url = url
    end

    class Project
      def initialize(name)
        @name = name
      end
    end

    class Issue
      def initialize(id)
        @id = id
      end
    end
  end
end
