require 'spec_helper'

describe Stack do
  before(:each) do
    @stack = Stack.new
  end

  describe '#pop' do
    it 'will pop a value' do
      @stack.push 5
      expect(@stack.pop).to eq(5)
      expect(@stack).to eq([])
    end

    it 'will pop a 0 if empty' do
      expect(@stack.pop).to eq(0)
      expect(@stack).to eq([])
      expect(@stack.pop).to eq(0)
    end
  end
end
