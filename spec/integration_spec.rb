require 'spec_helper'

describe BefungeInterpreter do
  describe 'hello world script' do
    it 'should print Hello, World!' do
      bfi = BefungeInterpreter.new('./spec/test_examples/hello_world.bf', [])
      expect { bfi.interpret }.to output('Hello, World!').to_stdout
    end
  end
end
