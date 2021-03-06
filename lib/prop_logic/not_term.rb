module PropLogic
  class NotTerm < Term
    def initialize(term)
      @terms = [term].freeze
      @is_nnf = @terms[0].is_a?(Variable)
      @is_reduced = @is_nnf && ! (@terms[0].is_a?(Constant))
    end

    def to_s(*)
      "~" + @terms[0].to_s(true)
    end

    def nnf?
      @is_nnf
    end

    def to_nnf
      term = @terms[0]
      case term
      when NotTerm
        term.terms[0].to_nnf
      when Variable
        self
      when ThenTerm
        (~(term.to_nnf)).to_nnf
      when AndTerm
        all_or(*term.terms.map{|t| (~t).to_nnf})
      when OrTerm
        all_and(*term.terms.map{|t| (~t).to_nnf})
      end
    end

    def reduced?
      @is_reduced
    end

    def reduce
      return self if reduced?
      reduced_term = @terms[0].reduce
      case reduced_term
      when TrueConstant
        False
      when FalseConstant
        True
      else
        (~reduced_term).to_nnf
      end
    end

    def to_cnf
      if reduced?
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

    alias_method :cnf?, :reduced?
  end
end
