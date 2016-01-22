module PropLogic
  #default
  @@sat_solver = PropLogic::BruteForceSatSolver
  
  def self.sat_solver
    @@sat_solver
  end
  
  def self.sat_solver=(engine)
    raise TypeError unless engine.respond_to?(:sat?)
    @@sat_solver = engine
  end
end
