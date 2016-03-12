module PropLogic
  #
  # Default implementation of incremental SAT solver.
  # Provided for reference implementation and avoiding non-existent error.
  # (Using normal solver, not incrementally)
  #
  class DefaultIncrementalSolver
    # @param [Term] initial term
    def initialize(term)
      @term = term
    end

    # Current term
    attr_reader :term

    # Adding new terms to this solver.
    # @param [Term] terms to add.
    # @return [DefaultIncrementalSolver] self
    def add(*terms)
      @term = @term.and(*terms)
      self
    end

    alias_method :<<, :add

    # Check satisfiability of terms.
    # @return [Term] if satisfied
    # @return [false] if unsatisfied
    def sat?
      @term.sat?
    end
  end
end
