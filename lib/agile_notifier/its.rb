module AgileNotifier
  class ITS
    include Servable

    def initialize(args)
      @url = args.fetch(:url)
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
