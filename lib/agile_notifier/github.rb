require_relative 'scm'

module AgileNotifier
  class Github < SCM

    class Commit < SCM::Commit
      def author

      end
    end
  end
end