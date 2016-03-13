require 'spec_helper'

describe 'PropLogic#each_sat' do
  let(:a) { PropLogic::Variable.new('a') }
  let(:b) { PropLogic::Variable.new('a') }

  context '(without block)' do
    it 'is an Enumerator object' do
      expect((a | b).each_sat).to be_a(Enumerator)
    end

    it 'repeats for all satisfiabilities' do
      expect((a | b).each_sat.count).to be 3
    end
  end

  context '(with block)' do
    it 'yields with Term' do
      expect do |bl|
        (a | b).each_sat(&bl).to yield_with_args(String)
      end
    end
    it 'doesn\'t yield when unsat' do
      expect do |bl|
        (a & ~a).each_sat(&bl).not_to yield_control
      end
    end
  end
end
