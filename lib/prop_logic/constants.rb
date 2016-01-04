require 'singleton'

module PropLogic
  class Constant < Variable
    def variables
      []
    end
  
    def to_cnf
      self
    end
    
  end
  
  class TrueConstant < Constant
    include Singleton
    def to_s(*)
      'true'
    end
    
    def assign(trues, falses, variables = nil)
      if falses.include?(self)
        raise ArgumentError, 'Contradicted assignment'
      end
      self
    end
    
  end
  
  class FalseConstant < Constant
    include Singleton
    def to_s(*)
      'false'
    end
    def assign(trues, falses, variables = nil)
      if trues.include?(self)
        raise ArgumentError, 'Contradicted assignment'
      end
      self
    end
  end
  
  True = TrueConstant.instance.freeze
  False = FalseConstant.instance.freeze
end
