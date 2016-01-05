module PropLogic
  module BruteForceSatSolver
    class << self
      def sat?(term)
        # obvious value
        return True if term == True
        variables = term.variables
        PropLogic.all_combination(variables) do |trues|
          falses = variables - trues
          next unless term.assign(trues, falses).reduce == True
          # SAT
          negated_falses = falses.map(&:not)
          return PropLogic.all_and(*trues, *negated_falses)
        end
        # UNSAT
        nil
      end
    end
  end
end
