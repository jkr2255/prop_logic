require 'ref'
require 'prop_logic/functions'

module PropLogic
  #
  # Abstract base class for terms of PropLogic.
  # Actual terms are subclasses of Term.
  #
  class Term
    include Functions

    # @raise NotImplementedError Term is abstract class.
    def initialize
      raise NotImplementedError, 'Term cannot be initialized'
    end

    # disallow duplication
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

    def self.generate_cache
      Ref::WeakValueMap.new
    end

    private_class_method :generate_cache

    def self.cached(klass, *terms)
      @table ||= generate_cache
      key = klass.name + terms.map(&:object_id).join(',')
      return @table[key] if @table[key]
      ret = klass.__send__ :new, *terms
      @table[key] = ret
      # kick caching mechanism
      ret.variables
      ret.freeze
    end

    private_class_method :cached

    def self.get(klass, *terms)
      terms = validate_terms(*terms)
      if klass == AndTerm || klass == OrTerm
        terms = terms.map { |t| t.is_a?(klass) ? t.terms : t }.flatten
        return terms[0] if terms.length == 1
      end
      cached klass, *terms
    end

    # check if this term is a cnf term.
    # @return [Boolean] false unless overridden.
    def cnf?
      false
    end

    # @return [Array] variables used by this term.
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

    # loop with each satisfied terms.
    # @return [Enumerator] if block is not given.
    # @return [nil] if block is given.
    def each_sat
      return to_enum(:each_sat) unless block_given?
      sat_loop(self) do |sat, solver|
        yield sat
        negated_vars = sat.terms.map do |t|
          t.is_a?(NotTerm) ? t.terms[0] : ~t
        end
        solver << PropLogic.all_or(*negated_vars)
      end
    end

    def unsat?
      sat? == false
    end

    def equiv?(other)
      ((self | other) & (~self | ~other)).unsat?
    end

    private

    # checking methods

    def check_term_uniqueness
      @is_reduced &&= (@terms.length == @terms.uniq.length)
    end

    def check_ambivalent_vars
      return unless @is_reduced
      term_by_class = @terms.group_by(&:class)
      return if term_by_class[NotTerm].nil? || term_by_class[Variable].nil?
      negated_variales = term_by_class[NotTerm].map { |t| t.terms[0] }
      @is_reduced = false unless (negated_variales & term_by_class[Variable]).empty?
    end

    def check_nnf_reduced
      @is_reduced = true
      @is_nnf = @terms.all? do |term|
        @is_reduced &&= !term.is_a?(Constant) && term.reduced?
        @is_reduced &&= !term.is_a?(NotTerm) || term.terms[0].is_a?(Variable)
        next true if @is_reduced
        term.nnf?
      end
      return unless @is_reduced
      check_term_uniqueness
      check_ambivalent_vars
    end

  end
end
