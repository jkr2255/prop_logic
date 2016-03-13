require 'spec_helper'

describe PropLogic::DefaultIncrementalSolver do
  let(:a) { PropLogic::Variable.new 'a' }
  let(:b) { PropLogic::Variable.new 'b' }
  let(:c) { PropLogic::Variable.new 'c' }

  expected_methods = [:add, :sat?, :<<, :term]

  expected_methods.each do |sym|
    it "has ##{sym} method" do
      expect(PropLogic::DefaultIncrementalSolver.public_instance_methods).to include sym
    end
  end

  describe '#add' do
    it 'can add one term properly' do
      s = PropLogic::DefaultIncrementalSolver.new a
      s.add(b)
      expect(s.term).to be_equiv(a & b)
    end

    it 'can add multiple terms properly' do
      s = PropLogic::DefaultIncrementalSolver.new a
      s.add(b, c)
      expect(s.term).to be_equiv(a & b & c)
    end

    it 'returns self' do
      s = PropLogic::DefaultIncrementalSolver.new a
      expect(s.add(b)).to be_equal(s)
    end
  end

  describe '#sat?' do
    context '(satisfiable)' do
      it 'returns satisfied term' do
        s = PropLogic::DefaultIncrementalSolver.new a
        s << (b | c)
        sat = s.sat?
        expect(s.term & sat).to be_sat
      end
    end

    context '(unsatisfiable)' do
      it 'returns false' do
        s = PropLogic::DefaultIncrementalSolver.new a
        s << ~a
        expect(s.sat?).to be false
      end
    end
  end
end
