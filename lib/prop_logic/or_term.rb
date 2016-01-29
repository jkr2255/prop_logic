module PropLogic
  class OrTerm < Term
    def initialize(*terms)
      @terms = terms.map{|t| t.is_a?(OrTerm) ? t.terms : t}.flatten.freeze
      @is_nnf = @terms.all?(&:nnf?) 
      @is_reduced = @is_nnf && @terms.all? do |term|
        if term.is_a?(Constant) || !(term.reduced?)
          false
        elsif !(term.is_a?(NotTerm))
          true
        else
          # NotTerm
          term.terms[0].is_a?(Variable)
        end
      end
      return unless @is_reduced
      # check duplication of terms
      if @terms.any?{ |term| @terms.index(term) != @terms.rindex(term)}
        @is_reduced = false
        return
      end
      # check obvious variables (mark as unreduced)
      # Negated terms (except variables) doesn't come here
      not_terms = @terms.select{ |t| t.is_a?(NotTerm) }
      negated_variales = not_terms.map{|t| t.terms[0]}
      @is_reduced = false unless (negated_variales & @terms).empty?
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
      reduced_terms = @terms.map(&:reduce).uniq
      reduced_terms.reject!{|term| term.equal?(False)}
      return False if reduced_terms.empty?
      if reduced_terms.any?{|term| term.equal?(True)}
        True
      elsif reduced_terms.length == 1
        reduced_terms[0]
      else
        not_terms = reduced_terms.select{|term| term.is_a?(NotTerm)}
        negated_terms = not_terms.map{|term| term.terms[0]}
        return True unless (negated_terms & reduced_terms).empty?
        Term.get self.class, *reduced_terms
      end
    end
    
    def cnf?
      return false unless reduced?
      ! @terms.any?{ |term| term.is_a?(AndTerm) }
    end
    
    def to_cnf
      return super unless reduced?
      return self if cnf?
      pool = []
      without_pools = tseitin(pool)
      all_and(without_pools, *pool)
    end
    
    def tseitin(pool)
      val = Variable.new
      terms = @terms.map{|t| t.tseitin(pool)}
      pool << (~val | all_or(*terms))
      val      
    end

  end
end
