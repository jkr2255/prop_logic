require 'ref'

module PropLogic
  class Term
    def initialize
      raise NotImplementedError, 'Term cannot be initialized'
    end
    
    class << self
      protected :new
    end

    attr_reader :terms
    
    def and(*others)
      others.unshift self
      Term.get AndTerm, *others
    end
    
    alias_method :&, :and
    
    def or(*others)
      others.unshift self
      Term.get OrTerm, *others
    end
    
    alias_method :|, :or
    
    def not
      Term.get NotTerm, self
    end
    
    alias_method :!, :not
    alias_method :-@, :not
    
    def then(other)
      Term.get ThenTerm, self, other
    end
    
    alias_method :>>, :then
    
    def to_s_in_term
      to_s true
    end
    
    def to_nnf
      if nnf?
        self
      else
        Term.get self.class, *@terms.map(&:to_nnf)
      end
    end
    
    def nnf?
      false
    end
    
    def to_cnf
      to_nnf.to_cnf
    end
    
    # TODO: accept true/false
    def self.validate_terms(*terms)
      raise TypeError unless terms.all?{ |term| term.is_a?(Term) }
      terms
    end
    
    def self.get(klass, *terms)
      @table ||= Ref::WeakValueMap.new
      terms = validate_terms(*terms)
      if klass == AndTerm || klass == OrTerm
        terms = terms.map{|t| t.is_a?(klass) ? t.terms : t}.flatten
      end 
      key = klass.name + terms.map(&:object_id).join(',')
      return @table[key] if @table[key]
      ret = klass.__send__ :new, *terms
      @table[key] = ret
      ret
    end
    
    def simple?
      false
    end
    
    protected :simple?
    
    def variables
      @terms.map(&:variables).flatten.uniq
    end
  end
end
