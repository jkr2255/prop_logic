require 'spec_helper'

describe PropLogic::BruteForceSatSolver do
  let(:a){PropLogic::Variable.new 'a'}
  let(:b){PropLogic::Variable.new 'b'}
  let(:c){PropLogic::Variable.new 'c'}
  let(:d){PropLogic::Variable.new 'd'}  

  context '.sat?' do
    it 'is a method' do
      expect(PropLogic::BruteForceSatSolver).to respond_to(:sat?)
    end
    
    it 'returns Term when satisfied' do
      expect(PropLogic::BruteForceSatSolver.sat?(a & b)).to be_a(PropLogic::Term)
    end
    
    it 'returns nil when unsatisfied' do
      expect(PropLogic::BruteForceSatSolver.sat?(a & !a)).to be nil
    end
    
    context '(edge cases)' do
      it 'returns nil when False is passed' do
        expect(PropLogic::BruteForceSatSolver.sat?(PropLogic::False)).to be nil
      end
      
      it 'returns True when True is passed' do
        expect(PropLogic::BruteForceSatSolver.sat?(PropLogic::True)).to be PropLogic::True
      end
    end
    
  end
end
