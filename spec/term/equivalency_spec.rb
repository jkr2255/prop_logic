require 'spec_helper'

describe 'PropLogic::Term#equiv?' do
  let(:a){PropLogic::Variable.new 'a'}
  let(:b){PropLogic::Variable.new 'b'}
  let(:c){PropLogic::Variable.new 'c'}
  let(:d){PropLogic::Variable.new 'd'}

  it 'returns true with the same terms' do
    term = (a & b) | (c >> ~d)
    expect(term).to be_equiv(term)
  end

  it 'returns false when variable set if different' do
    term1 = (a & b)
    term2 = (a | c) >> d
    expect(term1).not_to be_equiv(term2)
  end

  it 'returns true with double negation' do
    term = (a & b) | c
    expect(~~term).to be_equiv(term)
  end

  it 'returns true with terms of different orders' do
    term1 = (a & b) | (c & d)
    term2 = (d & c) | (b & a)
    expect(term1).to be_equiv(term2)
  end

  it 'returns true with De Morgan\'s law' do
    expect(~(a | b)).to be_equiv(~a & ~b)
    expect(~(a & b)).to be_equiv(~a | ~b)
  end

  it 'returns properly with variables' do
    expect(a).to be_equiv(a)
    expect(a).not_to be_equiv(b)
  end

  it 'returns true with redundant variables' do
    expect((a & b) | (~a & b)).to be_equiv(b)
  end

end
