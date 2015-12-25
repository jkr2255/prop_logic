require 'spec_helper'

describe PropLogic do
  it 'has a version number' do
    expect(PropLogic::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(PropLogic).to be_a(Module)
  end
end
