require 'spec_helper'

describe PropLogic::Term do
  it 'is a class' do
    expect(PropLogic::Term).to be_a(Class)
  end

  it 'cannot be instantiated directly' do
    expect{PropLogic::Term.new}.to raise_error(NoMethodError)
  end

  expected_methods = [:|, :&, :or, :and, :not, :~, :-@, :then, :>>,
  :to_nnf, :to_cnf, :nnf?, :terms, :variables]

  expected_methods.each do |sym|
    it "has ##{sym} method" do
      expect(PropLogic::Term.public_instance_methods).to include sym
    end
  end

end
