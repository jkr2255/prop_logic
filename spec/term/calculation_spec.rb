require 'spec_helper'

describe PropLogic::Term do
  a = PropLogic::new_variable 'a'
  b = PropLogic::new_variable 'b'
  terms1 = [a, !a, a & b, a | b, a >> b, PropLogic::True, PropLogic::False]
  c = PropLogic::new_variable 'c'
  d = PropLogic::new_variable 'd'
  terms2 = [c, !c, c & d, c | d, c >> d, PropLogic::True, PropLogic::False, true, false]
  
  terms1.each do |term|
    context "Not(#{term.class.name})" do
      it 'is a Term' do
        expect(!term).to be_a(PropLogic::Term)
      end
      it 'generates the same object during two operations' do
        expect(!term).to be_equal(!term)
      end
    end
    
    context "#{term.class.name}" do
      it 'is frozen' do
        expect(term).to be_frozen
      end
    end
  end
  
  terms1.product(terms2, [:&, :|, :>>]) do |term1, term2, op|
    context "#{term1.class.name} #{op} #{term2.class.name}" do
      it 'is a Term' do
        expect(term1.public_send(op, term2)).to be_a(PropLogic::Term)
      end
      it 'generates the same object during two operations' do
        expect(term1.public_send(op, term2)).to be_equal(term1.public_send(op, term2))
      end
    end
  end
  
  terms1.product([:&, :|, :>>]) do |term1, op|
    context "#{term1.class.name} #{op} (Incompatible type)" do
      it 'generates TypeError' do
        expect{term1.public_send(op, "test")}.to raise_error(TypeError)
      end
    end
  end
  
  terms1.each do |term|
    context "#{term.class}" do
      it 'cannot be duplicated' do
        expect{term.dup}.to raise_error(TypeError)
      end
    end
  end
  
end
