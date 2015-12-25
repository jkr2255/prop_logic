module PropLogic
  class NotTerm < Term
    def initialize(term)
      @terms = [term]
    end
    
    def to_s(*)
      "!" + @terms[0].to_s(true)
    end
    
    def nnf?
      @terms[0].is_a?(Variable)
    end
    
    def to_nnf
      term = @terms[0]
      case term
      when NotTerm
        term.terms[0].to_nnf
      when Variable
        self
      when ThenTerm
        (!(term.to_nnf)).to_nnf
      when AndTerm
        PropLogic.all_or(term.terms.map{|t| (!t).to_nnf})
      when OrTerm
        PropLogic.all_and(term.terms.map{|t| (!t).to_nnf})
      end
    end
    
    def to_cnf
      if nnf?
        self
      else
        super
      end
    end
    
    def tseitin(pool)
      if nnf?
        self
      elsif @terms[0].is_a?(NotTerm) && @terms[0].terms[0].is_a(Variable)
        @terms[0].terms[0]
      else
        raise 'Non-NNF terms cannot be converted to Tseitin form.' + self.to_s
      end
    end
    
    alias_method :simple?, :nnf?
  end
end