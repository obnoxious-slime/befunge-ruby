require 'spec_helper'

describe Position do
  it 'getter methods should get' do
    position = Position.new(10, 20)
    expect(position.x).to eq(10)
    expect(position.y).to eq(20)
  end

  it 'assigns 0,0 as it\'s first value' do
    position = Position.new
    expect(position.x).to eq(0)
    expect(position.y).to eq(0)
  end

  it 'setter methods should set' do
    position = Position.new

    position.x = 30
    position.y = 50
    expect(position.x).to eq(30)
    expect(position.y).to eq(50)
  end
end
