require 'spec_helper'

describe PropLogic::Term do
  let(:reduced_terms) do
  	a = PropLogic.new_variable('a')
  	b = PropLogic.new_variable('b')
  	c = PropLogic.new_variable('c')
  	d = PropLogic.new_variable('d')
    part1 = [ a, ~a, a & b, a | b, a & ~b, a | ~b]
    part2 = [ c, ~c, c & d, c | d, c & ~d, c | ~d]
    terms = part1.dup
    part1.product(part2) do |term1, term2|
      terms << (term1 & term2)
      terms << (term1 | term2)     
    end
    terms
  end
  
  let(:reducible_terms) do
  	a = PropLogic.new_variable('a')
  	b = PropLogic.new_variable('b')
  	c = PropLogic.new_variable('c')
  	d = PropLogic.new_variable('d')
    part1 = [~~a, ~(a & b), ~(a | b), a >> b, a | ~a, a & ~a, a & a, a | a]
    part2 = [~~c, ~(c & d), ~(c | d), c >> d, True, False, c | ~c, c & ~c, c & c, c | c]
    terms = part1.dup
    part1.product(part2) do |term1, term2|
      terms << (term1 & term2)
      terms << (term1 | term2)
      terms << (term1 >> term2)
      terms << (term1 | ~term2)
      terms << (term1 & ~term2)
      terms << (term1 >> ~term2)
    end
    terms
  end
  
  describe '#reduced?' do
    it 'returns properly (with reduced terms)' do
      reduced_terms.each do |term|
        expect(term).to be_reduced
      end
    end
    
    it 'returns properly (with reducible terms)' do
      reducible_terms.each do |term|
        expect(term).not_to be_reduced
      end
    end
  end
  
  describe '#reduce' do
    it 'returns equivalent, reduced terms' do
      reducible_terms.each do |term|
        reduced = term.reduce
        expect(reduced).to be_equiv(term)
        expect(reduced).to be_reduced
      end
    end
  end
  
end
