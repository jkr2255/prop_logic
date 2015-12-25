module PropLogic
  class ThenTerm < Term
    def initialize(term1, term2)
      @terms = [term1, term2]
    end
    
    def to_s(in_term = false)
      str = "#{@terms[0].to_s(true)} => #{@terms[1].to_s(true)}"
      in_term ? "( #{str} )" : str
    end
    
    def nnf?
      false
    end
    
    def to_nnf
      (!@terms[0]).to_nnf | @terms[1].to_nnf
    end
  end

end
