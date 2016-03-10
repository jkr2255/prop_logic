require 'spec_helper'

describe PropLogic::Variable do

  let(:a){PropLogic::new_variable 'a'}

  it 'is a term' do
    expect(a).to be_a(PropLogic::Term)
  end

  it 'can be instanciated directly' do
    expect{PropLogic::Variable.new}.not_to raise_error
  end

  it 'generates other variables even if strings are equal' do
    expect(PropLogic::new_variable 'a').not_to be_equal(PropLogic::new_variable 'a')
  end

  it 'has no term' do
    expect(a.terms).to eq []
  end

  it 'has one variable' do
    expect(a.variables.length).to eq 1
  end

  it 'is an NNF' do
    expect(a).to be_nnf
    expect(a.to_nnf).to be_equal(a)
  end

  it 'is a CNF' do
    expect(a.to_cnf).to be_equal(a)
  end

end
