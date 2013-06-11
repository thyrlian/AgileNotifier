module AgileNotifier
  module Service
    def is_available?
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end
  end
end