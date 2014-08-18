module AgileNotifier
  class ITS
    include Servable

    def initialize(args)
      @url = args.fetch(:url)
    end

    def query_amount_of_tickets(query)
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end

    def set_limit(project, query, limit)
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end

    def exceeds_limit?
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end
  end
end
