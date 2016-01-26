require 'spec_helper'

describe PropLogic::BruteForceSatSolver do
  let(:a){PropLogic::Variable.new 'a'}
  let(:b){PropLogic::Variable.new 'b'}
  let(:c){PropLogic::Variable.new 'c'}
  let(:d){PropLogic::Variable.new 'd'}  

  context 'call' do
    it 'is a method' do
      expect(PropLogic::BruteForceSatSolver).to respond_to(:call)
    end
    
    it 'returns Term when satisfied' do
      expect(PropLogic::BruteForceSatSolver.call(a & b)).to be_a(PropLogic::Term)
    end
    
    it 'returns false when unsatisfied' do
      expect(PropLogic::BruteForceSatSolver.call(a & !a)).to be false
    end
    
    context '(edge cases)' do
      it 'returns false when False is passed' do
        expect(PropLogic::BruteForceSatSolver.call(PropLogic::False)).to be false
      end
      
      it 'returns True when True is passed' do
        expect(PropLogic::BruteForceSatSolver.call(PropLogic::True)).to be PropLogic::True
      end
    end
    
  end
end
