require 'spec_helper'

describe Pointer do
  before(:each) { @pointer = Pointer.new }

  describe 'direction' do
    it 'initially gets a direction of east' do
      expect(@pointer.direction).to eq(:e)
    end

    it 'can be set post initialization' do
      @pointer.direction = :s
      expect(@pointer.direction).to eq(:s)
    end
  end

  describe 'position' do
    it 'should have a position' do
      expect(@pointer.instance_variable_get(:@x)).to_not eq(nil)
      expect(@pointer.instance_variable_get(:@y)).to_not eq(nil)
    end

    it 'has getters for position' do
      expect(@pointer).to respond_to(:x)
      expect(@pointer).to respond_to(:y)
    end

    it 'should initially set position to 0,0' do
      expect(@pointer.x).to eq(0)
      expect(@pointer.y).to eq(0)
    end

    it 'has setters for position' do
      @pointer.x = 55
      @pointer.y = 12
      expect(@pointer.x).to eq(55)
      expect(@pointer.y).to eq(12)
    end
  end

  describe 'step' do
    it 'steps west correctly' do
      @pointer.direction = :e
      @pointer.step
      expect(@pointer.x).to eq(1)
      expect(@pointer.y).to eq(0)
    end
    it 'steps east correctly' do
      @pointer.step
      expect(@pointer.x).to eq(1)
      expect(@pointer.y).to eq(0)
    end
    it 'steps north correctly' do
      @pointer.x = 10
      @pointer.y = 10
      @pointer.direction = :n
      @pointer.step
      expect(@pointer.x).to eq(10)
      expect(@pointer.y).to eq(9)
    end
    it 'steps south correctly' do
      @pointer.direction = :s
      @pointer.step
      expect(@pointer.x).to eq(0)
      expect(@pointer.y).to eq(1)
    end
  end

  describe 'trampoline' do
    it 'initially starts with a falsly trampoline status' do
      expect(@pointer.trampoline).to eq(false)
    end

    it 'when truthy, assigns it to a falsy value in step' do
      @pointer.trampoline = true
      expect(@pointer.trampoline).to eq(true)

      @pointer.step
      expect(@pointer.trampoline).to eq(false)
      @pointer.step
      expect(@pointer.trampoline).to eq(false)
    end

    it 'jumps over a western point' do
      @pointer.x = 10
      @pointer.y = 10
      @pointer.direction = :w
      @pointer.trampoline = true
      @pointer.step
      expect(@pointer.x).to eq(8)
      expect(@pointer.y).to eq(10)
      @pointer.step
      expect(@pointer.x).to eq(7)
      expect(@pointer.y).to eq(10)
    end

    it 'jumps over a easter point' do
      @pointer.trampoline = true
      @pointer.step
      expect(@pointer.x).to eq(2)
      expect(@pointer.y).to eq(0)
      @pointer.step
      expect(@pointer.x).to eq(3)
      expect(@pointer.y).to eq(0)
    end

    it 'jumps over a northern point' do
      @pointer.x = 10
      @pointer.y = 10
      @pointer.direction = :n
      @pointer.trampoline = true
      @pointer.step
      expect(@pointer.x).to eq(10)
      expect(@pointer.y).to eq(8)
      @pointer.step
      expect(@pointer.x).to eq(10)
      expect(@pointer.y).to eq(7)
    end
    it 'jumps over a southern point' do
      @pointer.direction = :s
      @pointer.trampoline = true
      @pointer.step
      expect(@pointer.x).to eq(0)
      expect(@pointer.y).to eq(2)
      @pointer.step
      expect(@pointer.x).to eq(0)
      expect(@pointer.y).to eq(3)
    end
  end

  describe 'wrap around' do
    it 'correctly wraps around the west side' do
      @pointer.direction = :w
      @pointer.step
      expect(@pointer.x).to eq(79)
    end
    it 'correctly wraps around the south side' do
      @pointer.y = 19
      @pointer.direction = :s
      @pointer.step
      expect(@pointer.y).to eq(0)
    end
    it 'correctly wraps around the north side' do
      @pointer.direction = :n
      @pointer.step
      expect(@pointer.y).to eq(19)
    end
    it 'correctly wraps around the east side' do
      @pointer.direction = :e
      @pointer.x = 79
      @pointer.step
      expect(@pointer.x).to eq(0)
    end
  end
end
