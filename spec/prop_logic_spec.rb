require 'spec_helper'

describe PropLogic do
  it 'has a version number' do
    expect(PropLogic::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(PropLogic).to be_a(Module)
  end
  
  describe '#sat_solver' do
    it 'returns Object responding to sat?' do
      expect(PropLogic.sat_solver).to respond_to(:sat?)
    end
  end
  
  describe '#sat_solver=' do
    it 'can be assinged with object responding to sat?' do
      solver_mock = double('solver')
      allow(solver_mock).to receive(:sat?)
      expect{PropLogic.sat_solver = solver_mock}.not_to raise_error
    end
  
    it 'raises TypeError when sat? method not found' do
      expect{PropLogic.sat_solver = nil}.to raise_error(TypeError)
    end
    
    after do
      PropLogic.sat_solver = PropLogic::BruteForceSatSolver
    end
  end
end
