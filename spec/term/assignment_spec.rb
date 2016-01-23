require 'spec_helper'

describe 'PropLogic::Term#assign' do
  let(:a){PropLogic::Variable.new 'a'}
  let(:b){PropLogic::Variable.new 'b'}
  let(:c){PropLogic::Variable.new 'c'}
  let(:d){PropLogic::Variable.new 'd'}
  
  context 'proper assignment' do
    it 'can be assigned to one level binary term' do
      [:|, :&, :>>].each do |op|
        expect(a.public_send(op, b).assign_true(a)).to be_equal(True.public_send(op, b))
        expect(a.public_send(op, b).assign_false(a)).to be_equal(False.public_send(op, b))
        expect(a.public_send(op, b).assign_true(b)).to be_equal(a.public_send(op, True))
        expect(a.public_send(op, b).assign_false(b)).to be_equal(a.public_send(op, False))
      end
    end
    
    it 'can be assigned to one level uniary term' do
      expect((~a).assign_true(a)).to be_equal(~True)
      expect((~a).assign_false(a)).to be_equal(~False)
    end
    
    it 'can be assigned to multi level terms' do
      expect( ((a & b) | (a >> c)).assign_true(a) ).to be_equal((True & b) | (True >> c))
      expect( ((a & b) | (a >> c)).assign_true(b) ).to be_equal((a & True) | (a >> c))
      expect( ((a & b) | (a >> c)).assign_true(c) ).to be_equal((a & b) | (a >> True))
      expect( ((a & b) | (a >> c)).assign_false(a) ).to be_equal((False & b) | (False >> c))
      expect( ((a & b) | (a >> c)).assign_false(b) ).to be_equal((a & False) | (a >> c))
      expect( ((a & b) | (a >> c)).assign_false(c) ).to be_equal((a & b) | (a >> False))
    end
    
    it 'can be assigned to varibles' do
      expect(a.assign_true(a)).to be_equal(True)
      expect(a.assign_false(a)).to be_equal(False)
    end
  end
  
  context 'assignment with no effect' do
    it 'can be assigned with variables not in the term' do
      term = (a & b) | (a >> c)
      expect(term.assign_true(d)).to be_equal(term)
      expect(term.assign_false(d)).to be_equal(term)
    end
    
    it 'can be assigned to other variable' do
      expect(a.assign_true(b)).to be_equal(a)
      expect(a.assign_false(b)).to be_equal(a)
    end
  
    it 'can be assigned to True/False' do
      expect(True.assign_true(True)).to be_equal(True)
      expect(False.assign_false(False)).to be_equal(False)
    end
  end
  
  context 'contradicted assignment' do
    it 'causes error when assigned to true/false at the same time' do
      expect{(a & b).assign([a],[a])}.to raise_error
    end
    
    it 'causes error when trying to assign True to False / vice versa' do
      expect{True.assign_false(True)}.to raise_error
      expect{False.assign_true(False)}.to raise_error
    end
  end
  
end
