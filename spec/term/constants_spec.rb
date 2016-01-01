require 'spec_helper'

True = PropLogic::True
False = PropLogic::False

describe PropLogic::True do

  let(:a){PropLogic::Variable.new('a')}
  let(:b){PropLogic::Variable.new('a')}
  
  it 'is a term' do
    expect(True.is_a?(PropLogic::Term)).to be true
  end
  
  it 'becomes False when negated and reduced' do
    expect((!True).reduce).to be_equal(False)
  end
  
  it 'is ignored in and terms when reduced' do
    expect((True & a).reduce).to be_equal(a)
  end
  
  it 'makes or terms True when one term is True' do
    expect((a | True).reduce).to be_equal(True)
    expect((True | a).reduce).to be_equal(True)
    expect((a | b | True).reduce).to be_equal(True)
  end
  
  it 'makes then term a result (in condition)' do
    expect((True >> a).reduce).to be_equal(a)
  end
  
  it 'makes then term True (in result)' do
    expect((a >> True).reduce).to be_equal(True)
  end
  
end

describe PropLogic::False do

  let(:a){PropLogic::Variable.new('a')}
  let(:b){PropLogic::Variable.new('a')}
  
  it 'is a term' do
    expect(False.is_a?(PropLogic::Term)).to be true
  end
  
  it 'becomes True when negated and reduced' do
    expect((!False).reduce).to be_equal(True)
  end
  
  it 'is ignored in or terms when reduced' do
    expect((False | a).reduce).to be_equal(a)
  end

  it 'makes and terms False when one term is False' do
    expect((a & False).reduce).to be_equal(False)
    expect((False & a).reduce).to be_equal(False)
    expect((a & b & False).reduce).to be_equal(False)
  end

  it 'makes then term True (in condition)' do
    expect((False >> a).reduce).to be_equal(True)
  end
  
  it 'makes then term a negation of condition (in result)' do
    expect((a >> False).reduce).to be_equal(!a)
  end
  
end
