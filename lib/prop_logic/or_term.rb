module PropLogic
  class OrTerm < Term
    def initialize(*terms)
      @terms = terms.map{|t| t.is_a?(OrTerm) ? t.terms : t}.flatten
      @is_nnf = @terms.all?(&:nnf?) 
      @is_reduced = @terms.all? do |term|
        term.reduced? && ! term.is_a?(Constant)
      end
    end
    
    def to_s(in_term = false)
      str = @terms.map(&:to_s_in_term).join(' | ')
      in_term ? "( #{str} )" : str
    end
    
    def nnf?
      @is_nnf
    end
    
    def reduced?
      @is_reduced
    end
    
    def reduce
      return self if reduced?
      reduced_terms = @terms.map(&:reduce)
      reduced_terms.reject!{|term| term.equal?(False)}
      return False if reduced_terms.empty?
      if reduced_terms.any?{|term| term.equal?(True)}
        True
      elsif reduced_terms.length == 1
        reduced_terms[0]
      else
        Term.get self.class, *reduced_terms
      end
    end
    
    def to_cnf
      return super unless reduced?
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
