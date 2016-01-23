require 'spec_helper'

describe PropLogic::ThenTerm do
  let(:a){PropLogic::Variable.new('a')}
  let(:b){PropLogic::Variable.new('b')}

  it 'cannot be instantiated directly' do
    expect{PropLogic::AndTerm.new}.to raise_error(NoMethodError)
  end

  it 'is not an nnf term' do
    expect(a >> b).not_to be_nnf
  end
  
  it 'is equivalent to !a | b' do
    expect(a >> b).to be_equiv(~a | b)
  end
end
