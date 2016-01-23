require 'spec_helper'

describe PropLogic::Term do
  let(:nnf_terms) do
  	a = PropLogic.new_variable(a)
  	b = PropLogic.new_variable(b)
  	c = PropLogic.new_variable(c)
  	d = PropLogic.new_variable(d)
	[
	  a,
	  a & b,
	  a | b,
	  ~a,
	  (a & b) | c,
	  (~a | ~b) & ~c,
	  (a | ~b) & (~c | d),
	  a & True,
	  a | False,
	]
  end
  
  let(:not_nnf_terms) do
  	a = PropLogic.new_variable(a)
  	b = PropLogic.new_variable(b)
  	c = PropLogic.new_variable(c)
  	d = PropLogic.new_variable(d)
	[
	  ~~a,
	  ~(a | b),
	  a >> b,
	  (a & ~~ b),
	  a & ~(b | c),
	]
  end
  
  describe '#nnf?' do
    it 'returns correctly (with nnf terms)' do
	  nnf_terms.each do |term|
	    expect(term).to be_nnf
	  end
	end
	
    it 'returns correctly (with non-nnf terms)' do
	  not_nnf_terms.each do |term|
	    expect(term).not_to be_nnf
	  end
	end
  end
  
  describe '#to_nnf' do
  	it 'returns the same object (with nnf terms)' do
	  nnf_terms.each do |term|
	    expect(term.to_nnf).to be_equal(term)
	  end
	end
	
  	it 'returns equivalent & nnf object (with non-nnf terms)' do
	  not_nnf_terms.each do |term|
	    nnf_term = term.to_nnf
	    expect(nnf_term).to be_equiv(term)
		expect(nnf_term).to be_nnf
	  end
	end
  end
end
