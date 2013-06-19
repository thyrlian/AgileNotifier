module AgileNotifier
  module Trackable
    def failed?
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end

    def passed?
      raise(NotImplementedError, "Abstract method [#{__method__}] is called, please implement", caller)
    end
  end
end