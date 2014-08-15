module AgileNotifier
  class ITS
    include Servable

    def initialize(url, *args)
      @url = url
      @args = args
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
