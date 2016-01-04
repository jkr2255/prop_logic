require 'spec_helper'

describe PropLogic::OrTerm do
  let(:terms1) do
    a = PropLogic::new_variable 'a'
    b = PropLogic::new_variable 'b'
    {
      variable: a,
      not: !a,
      and: (a & b),
      then: (a >> b),
    }
  end
  
  let(:terms2) do
    c = PropLogic::new_variable 'c'
  	d = PropLogic::new_variable 'd'
    {
      variable: c,
      not: !c,
      and: (c & d),
      then: (c >> d),
    }
  end
  
  it 'cannot be instantiated directly' do
    expect{PropLogic::OrTerm.new}.to raise_error(NoMethodError)
  end
  
  it 'generates the same object regardless on associativity' do
    e = PropLogic::new_variable 'e'
    f = PropLogic::new_variable 'f'
    g = PropLogic::new_variable 'g'
    expect((e | f) | g).to be_equal(e | (f | g))
  end
  
  it 'can be reduced to True with obvious conditions' do
    e = PropLogic::new_variable 'e'
    expect((e | !e).reduce).to be_equal(True)
  end
end
