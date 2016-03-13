module PropLogic
  #
  # Utility methods for PropLogic.
  #
  module Functions

    module_function

    # Combine all terms with or.
    # @param [Term] terms to combine
    # @return [Term] combined term
    def all_or(*args)
      Term.get OrTerm, *args
    end

    # Combine all terms with and.
    # @param [Term] terms to combine
    # @return [Term] combined term
    def all_and(*args)
      Term.get AndTerm, *args
    end

    # Create new variable.
    def new_variable(*args)
      Variable.new(*args)
    end

    # loop while satisfiable.
    # Note: Loop continues infinitely if no addition was given inside the loop.
    # @yield [Term, IncrementalSolver] yield for each term.
    def sat_loop(initial_term)
      incremental = PropLogic.incremental_solver.new initial_term
      loop do
        sat = incremental.sat?
        break unless sat
        yield sat, incremental
      end
    end
  end

  extend Functions
  include Functions
  public_class_method(*Functions.private_instance_methods(false))

  def all_combination(arr)
    0.upto(arr.length) do |num|
      arr.combination(num) { |c| yield c }
    end
  end

  module_function :all_combination

end
