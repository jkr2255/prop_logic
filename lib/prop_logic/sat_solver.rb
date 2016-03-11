# :nodoc:
module PropLogic
  # default SAT solver.
  # only intended for test use.
  @sat_solver = PropLogic::BruteForceSatSolver

  class << self
    # @return [Object] current SAT solver
    attr_reader :sat_solver

    # @param [Object] new SAT solver.
    #   It must have #call(term) method
    def sat_solver=(engine)
      raise TypeError unless engine.respond_to?(:call)
      @sat_solver = engine
    end
  end
end
