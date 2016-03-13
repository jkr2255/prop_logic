# :nodoc:
module PropLogic
  # default SAT solver.
  # only intended for test use.
  @sat_solver = PropLogic::BruteForceSatSolver
  @incremental_solver = PropLogic::DefaultIncrementalSolver

  class << self
    # @return [Object] current SAT solver
    attr_reader :sat_solver

    # @param [Object] new SAT solver.
    #   It must have #call(term) method
    def sat_solver=(engine)
      raise TypeError unless engine.respond_to?(:call)
      @sat_solver = engine
    end

    # curreent incremental solver
    attr_accessor :incremental_solver

  end
end
