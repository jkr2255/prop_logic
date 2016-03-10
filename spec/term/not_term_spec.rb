require 'spec_helper'

describe PropLogic::NotTerm do
  let(:terms) do
    a = PropLogic::new_variable 'a'
    b = PropLogic::new_variable 'b'
    {
      variable: ~a,
      not: ~~a,
      and: ~(a & b),
      or: ~(a | b),
      then: ~(a >> b),
    }
  end

  it 'cannot be instantiated directly' do
    expect{PropLogic::NotTerm.new}.to raise_error(NoMethodError)
  end

  it 'has only one term' do
    terms.values do |term|
      expect(term.terms.length).to eq 1
    end
  end

  it 'has exact the same variables as its term' do
    terms.values do |term|
      expect(term.variables.sort).to eq(term.terms[0].variables.sort)
    end
  end

  it 'is an nnf term only when its term is a variable' do
    terms.values do |term|
      expect(term.nnf?).to eq(term.terms[0].is_a?(PropLogic::Variable))
    end
  end

  it 'is a cnf term only when its term is a variable' do
    expect(terms[:variable].to_cnf).to be_equal(terms[:variable])
    other_terms=terms.dup
    other_terms.delete(:variable)
    terms.values do |term|
      expect(term.to_cnf).not_to be_equal(term)
    end
  end


end
