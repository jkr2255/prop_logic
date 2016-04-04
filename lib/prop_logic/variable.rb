module PropLogic
  class Variable < Term
    def initialize(name = nil)
      @name = name || "v_#{object_id}"
      @terms = [].freeze
      freeze
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

    def cnf?
      true
    end

    def variables
      [self]
    end

    def assign(trues, falses, variables = nil)
      if trues.include? self
        True
      elsif falses.include? self
        False
      else
        self
      end
    end

    # bypassing Term.get
    # @return [NotTerm] negated variable
    def not
      Term.__send__ :cached, "#{NotTerm.name}#{object_id}", NotTerm, self
    end

    alias_method :~, :not
    alias_method :-@, :not


  end
end
