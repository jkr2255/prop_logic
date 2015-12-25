module PropLogic
  class OrTerm < Term
    def initialize(*terms)
      @terms = terms.map{|t| t.is_a?(OrTerm) ? t.terms : t}.flatten
      @is_nnf = @terms.all?(&:nnf?) 
    end
    def to_s(in_term = false)
      str = @terms.map(&:to_s_in_term).join(' | ')
      in_term ? "( #{str} )" : str
    end
    def nnf?
      @is_nnf
    end
    
    def to_cnf
      return super unless nnf?
      return self if simple?
      pool = []
      without_pools = tseitin(pool)
      PropLogic.all_and(without_pools, *pool)
    end
    
    def tseitin(pool)
      val = Variable.new
      terms = @terms.map{|t| t.tseitin(pool)}
      pool << (!val | CnfMaker.all_or(terms))
      val      
    end

    def simple?
      @terms.all? do |t|
        t.is_a?(Variable) || (t.is_a?(NotTerm) && t.simple?)
      end
    end
  end
end
