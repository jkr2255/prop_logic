require 'spec_helper'

describe PropLogic::Term do
  let(:cnf_terms) do
  	a = PropLogic.new_variable('a')
  	b = PropLogic.new_variable('b')
  	c = PropLogic.new_variable('c')
  	d = PropLogic.new_variable('d')
	[
	  a, a & b, a | b, a & ~b, a & (b | c), (~a | b) & (c | ~d), True
	]
  end
  
  let(:non_cnf_terms) do
  	a = PropLogic.new_variable('a')
  	b = PropLogic.new_variable('b')
  	c = PropLogic.new_variable('c')
  	d = PropLogic.new_variable('d')
	[
	  ~~a, ~(a & b), a | ~a, a & ~a, a | (b & c), True | a, True & b, (a | b) & (c | ~~d) 
	]
  end
  
  context '#cnf?' do
  	it 'returns properly (with cnf terms)' do
	  cnf_terms.each do |term|
	  	expect(term).to be_cnf
	  end
	end
	
  	it 'returns properly (with non-cnf terms)' do
	  non_cnf_terms.each do |term|
	  	expect(term).not_to be_cnf
	  end
	end
  end
  
  context '#to_cnf' do
  	it 'returns cnf & equisatisfiable term (with non-cnf terms)' do
	  non_cnf_terms.each do |term|
	  	cnf = term.to_cnf
	  	expect(cnf).to be_cnf
      sat_result = cnf.sat?
      if sat_result
        expect(term & sat_result).to be_sat
      else
        expect(term).to be_unsat
      end
	  end
	end
  end
  
end
