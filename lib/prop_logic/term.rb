require 'ref'
require 'prop_logic/functions'

module PropLogic
  class Term
    include Functions
  
    def initialize
      raise NotImplementedError, 'Term cannot be initialized'
    end
    
    def initialize_copy(*)
      raise TypeError, 'Term cannot be duplicated (immutable, not necessary)'
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
    
    alias_method :~, :not
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
    
    def reduce
      if reduced?
        self
      else
        Term.get self.class, *@terms.map(&:reduce)
      end
    end
    
    def reduced?
      false
    end
    
    def to_cnf
      reduce.to_cnf
    end
    
    def self.validate_terms(*terms)
      raise ArgumentError, 'no terms given' if terms.empty?
      terms.map do |term|
        case term
        when TrueClass
          True
        when FalseClass
          False
        when Term
          term
        else
          raise TypeError, "#{term.class} cannot be treated as term"
        end
      end
    end
    
    private_class_method :validate_terms
    
    def self.get(klass, *terms)
      @table ||= Ref::WeakValueMap.new
      terms = validate_terms(*terms)
      if klass == AndTerm || klass == OrTerm
        terms = terms.map{|t| t.is_a?(klass) ? t.terms : t}.flatten
        return terms[0] if terms.length == 1
      end 
      key = klass.name + terms.map(&:object_id).join(',')
      return @table[key] if @table[key]
      ret = klass.__send__ :new, *terms
      @table[key] = ret
      # kick caching mechanism
      ret.variables
      ret.freeze
    end
    
    def cnf?
      false
    end
    
    def variables
      @variables ||= @terms.map(&:variables).flatten.uniq
    end
    
    def assign(trues, falses, variables = nil)
      # contradicted assignment
      raise ArgumentError, 'Contradicted assignment' unless (trues & falses).empty?
      variables ||= trues | falses
      assigned_terms = terms.map do |term|
        if (term.variables & variables).empty?
          term
        else
          term.assign(trues, falses, variables)
        end
      end
      Term.get self.class, *assigned_terms
    end
    
    def assign_true(*variables)
      assign variables, []
    end
    
    def assign_false(*variables)
      assign [], variables
    end
        
    def sat?
      PropLogic.sat_solver.call(self)
    end
    
    def unsat?
      sat? == false
    end
    
    def equiv?(other)
      ((self | other) & (~self | ~other)).unsat? 
    end
    
  end
end
