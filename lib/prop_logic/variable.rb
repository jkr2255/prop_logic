module PropLogic
  class Variable < Term
    def initialize(name = nil)
      @name = name || "v_#{object_id}"
      @terms = nil
    end
    
    public_class_method :new
    
    def to_s(*)
      @name
    end
    
    def nnf?
      true
    end
    
    def reduced?
      true
    end
    
    def to_cnf
      self
    end
    
    def tseitin(pool)
      self
    end
    
    def simple?
      true
    end
    
    def variables
      [self]
    end
  end
end
