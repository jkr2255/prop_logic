module PropLogic
  class AndTerm < Term
    def initialize(*terms)
      @terms = terms.map{|t| t.is_a?(AndTerm) ? t.terms : t}.flatten.freeze
      @is_nnf = @terms.all?(&:nnf?)
      # term with negative terms are no longer terated as reduced
      @is_reduced = @terms.all? do |term|
        term.reduced? && ! term.is_a?(Constant) && !term.is_a?(NotTerm)
      end
    end
    
    def to_s(in_term = false)
      str = @terms.map(&:to_s_in_term).join(' & ')
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
      reduced_terms.reject!{|term| term.equal?(True)}
      return True if reduced_terms.empty?
      if reduced_terms.any?{|term| term.equal?(False)}
        False
      elsif reduced_terms.length == 1
        reduced_terms[0]
      else
        # detect contradicted terms
        not_terms = reduced_terms.select{|term| term.is_a?(NotTerm)}
        negated_terms = not_terms.map{|term| term.terms[0]}
        return False unless (negated_terms & reduced_terms).empty?
        Term.get self.class, *reduced_terms
      end
    end
    
    def to_cnf
      return super unless reduced?
      return self if @terms.all?(&:simple?)
      pool = []
      without_pools = CnfMaker.all_and(*@terms.map{|t| t.tseitin(pool)})
      PropLogic.all_and(without_pools, *pool)
    end
    
    def tseitin(pool)
      val = Variable.new
      terms = @terms.map{|t| t.simple? ? t : t.tseitin(pool)}
      pool.concat terms.map{|t| !val | t }
      val
    end
    
    def simple?
      @terms.all? do |t|
        t.is_a?(Variable) || (t.is_a?(NotTerm) && t.simple?)
      end
    end
  end
end
