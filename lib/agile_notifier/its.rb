module AgileNotifier
  class ITS
    include Servable

    def initialize(args)
      @url = args.fetch(:url)
    end

    def query_amount_of_tickets(query)
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
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
