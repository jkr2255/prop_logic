require 'spec_helper'

describe PropLogic do
  it 'has a version number' do
    expect(PropLogic::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(PropLogic).to be_a(Module)
  end

  describe '#sat_solver' do
    it 'returns Object responding to call' do
      expect(PropLogic.sat_solver).to respond_to(:call)
    end
  end

  describe '#sat_solver=' do
    it 'can be assinged with object responding to call' do
      solver_mock = double('solver')
      allow(solver_mock).to receive(:call)
      expect{PropLogic.sat_solver = solver_mock}.not_to raise_error
    end

    it 'raises TypeError when call method not found' do
      expect{PropLogic.sat_solver = nil}.to raise_error(TypeError)
    end

    after do
      PropLogic.sat_solver = PropLogic::BruteForceSatSolver
    end
  end

  describe '.all_and' do
    a = PropLogic.new_variable 'a'
    b = PropLogic.new_variable 'b'

    it 'returns logical multipication in correct order' do
      expect(PropLogic.all_and(a, b)).to be_equal(a & b)
    end

    it 'returns given parameter when only one is passed' do
      expect(PropLogic.all_and(a)).to be_equal(a)
    end

    it 'raises ArgumentError when no parameter is given' do
      expect{PropLogic.all_and()}.to raise_error(ArgumentError)
    end

  end

  describe '.all_or' do
    a = PropLogic.new_variable 'a'
    b = PropLogic.new_variable 'b'

    it 'returns logical sum in correct order' do
      expect(PropLogic.all_or(a, b)).to be_equal(a | b)
    end

    it 'returns given parameter when only one is passed' do
      expect(PropLogic.all_or(a)).to be_equal(a)
    end

    it 'raises ArgumentError when no parameter is given' do
      expect{PropLogic.all_or()}.to raise_error(ArgumentError)
    end

  end
end
