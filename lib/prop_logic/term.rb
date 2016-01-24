require 'ref'

module PropLogic
  class Term
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
      ret.freeze
    end
    
    def cnf?
      false
    end
    
    def variables
      @terms.map(&:variables).flatten.uniq
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
        
    def reducible_to_constant?(trues, falses)
      step_reduced = assign(trues, falses).reduce
      return step_reduced if step_reduced.is_a?(Constant)
      # test all residue variables
      ret = nil
      PropLogic.all_combination(step_reduced.variables) do |reduced_trues|
        reduced_falses = step_reduced.variables - reduced_trues
        last = step_reduced.assign(reduced_trues, reduced_falses).reduce
        if ret
          return nil if last != ret
        else
          ret = last
        end
      end
      ret
    end
    
    protected :reducible_to_constant?
    
    def sat?
      PropLogic.sat_solver.sat?(self)
    end
    
    def unsat?
      sat? == false
    end
    
    def equiv?(other)
      ((self | other) & (~self | ~other)).unsat? 
    end
    
  end
end
