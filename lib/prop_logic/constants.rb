require 'singleton'

module PropLogic
  class Constant < Variable
    def to_cnf
      self
    end
  end
  
  class TrueConstant < Constant
    include Singleton
    def to_s(*)
      'true'
    end
  end
  
  class FalseConstant < Constant
    include Singleton
    def to_s(*)
      'false'
    end
  end
  
  True = TrueConstant.instance
  False = FalseConstant.instance
end
