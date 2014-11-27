require 'spec_helper'

describe Operations do
  before(:each) do
    @pointer = double(:pointer)
    @code_map = double(:code_map)

    @bfi = BefungeInterpreter.new('./spec/test_examples/hello_world.bf', [])
    @bfi.instance_variable_set(:@code_map, @code_map)

    allow(@code_map).to receive_messages(
      :set_operation => true,
      :get_operation_at => '#',
      :pointer => @pointer
    )

    allow(@pointer).to receive_messages(
      :direction= => true,
      :trampoline= => true
    )

    @empty_stack = Stack.new
  end

  describe 'initialization' do
    it 'sets code_map' do
      expect(@bfi.instance_variable_get(:@code_map)).to_not eq(nil)
    end

    it 'sets stack' do
      expect(@bfi.instance_variable_get(:@stack)).to_not eq(nil)
    end

    it 'stack to be instance of Stack' do
      stack = @bfi.instance_variable_get(:@stack)
      expect(stack.class).to eq(Stack)
    end

    it 'initializes string_mode to false' do
      expect(@bfi.instance_variable_get(:@string_mode)).to eq(false)
    end

    it 'initializes computing to true' do
      expect(@bfi.instance_variable_get(:@computing)).to eq(true)
    end
  end

  describe 'operations' do
    describe 'spaces' do
      # I test to see if any state has changed here
      it 'ignores spaces' do
        @bfi.instance_variable_set(:@stack, [1, 2, 3])
        expect(@bfi.operate!(' ')).to eq(nil)
        @bfi.operate!(' ')
        expect(@bfi.instance_variable_get(:@stack)).to eq([1, 2, 3])
        expect(@bfi.instance_variable_get(:@string_mode)).to eq(false)
        expect(@pointer).to_not receive(:direction=)
        expect(@pointer).to_not receive(:trampoline=)
        expect(@code_map).to_not receive(:set_operation)
        expect(@code_map).to_not receive(:get_operation_at)
      end
    end

    describe 'math' do
      before(:each) { @bfi.instance_variable_set(:@stack, [100, 55]) }

      describe '+' do
        it 'RPN adds' do
          @bfi.operate!('+')
          expect(@bfi.instance_variable_get(:@stack)).to eq([155])
        end
      end

      describe '-' do
        it 'RPN subtracts' do
          @bfi.operate!('-')
          expect(@bfi.instance_variable_get(:@stack)).to eq([45])
        end
      end

      describe '*' do
        it 'RPN multiplies' do
          @bfi.operate!('*')
          expect(@bfi.instance_variable_get(:@stack)).to eq([5500])
        end
      end

      describe '/' do
        it 'RPN divides' do
          @bfi.operate!('/')
          expect(@bfi.instance_variable_get(:@stack)).to eq([1])
        end
      end

      describe '%' do
        it 'RPN Modulos' do
          @bfi.operate!('%')
          expect(@bfi.instance_variable_get(:@stack)).to eq([45])
        end
      end
    end

    describe 'directions' do
      describe '<' do
        it 'point pointer west' do
          @bfi.operate!('<')
          expect(@pointer).to have_received(:direction=).with(:w)
        end
      end

      describe '>' do
        it 'point pointer east' do
          @bfi.operate!('>')
          expect(@pointer).to have_received(:direction=).with(:e)
        end
      end

      describe '^' do
        it 'point pointer north' do
          @bfi.operate!('^')
          expect(@pointer).to have_received(:direction=).with(:n)
        end
      end

      describe 'v' do
        it 'point pointer south' do
          @bfi.operate!('v')
          expect(@pointer).to have_received(:direction=).with(:s)
        end
      end
    end

    describe '"' do
      it 'sets and unsets string_mode' do
        expect(@bfi.instance_variable_get(:@string_mode)).to eq(false)

        @bfi.operate!('"')
        expect(@bfi.instance_variable_get(:@string_mode)).to eq(true)

        @bfi.operate!('"')
        expect(@bfi.instance_variable_get(:@string_mode)).to eq(false)
      end

      it 'stores operators by their ascii value' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!('"')
        @bfi.operate!('0')
        @bfi.operate!('a')
        @bfi.operate!('b')
        @bfi.operate!('c')
        expected = [48, 97, 98, 99]
        expect(@bfi.instance_variable_get(:@stack)).to eq(expected)
      end
    end

    describe 'numbers' do
      it 'pushes numbers onto the stack' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!('9')
        @bfi.operate!('3')
        @bfi.operate!('2')
        expect(@bfi.instance_variable_get(:@stack)).to eq([9, 3, 2])
      end
    end

    describe '!' do
      it 'pops of the stack and pushes 0' do
        @bfi.instance_variable_set(:@stack, [20])
        @bfi.operate!('!')
        expect(@bfi.instance_variable_get(:@stack)).to eq([0])
      end

      it 'pops of the stack and pushes 1' do
        @bfi.instance_variable_set(:@stack, [0])
        @bfi.operate!('!')
        expect(@bfi.instance_variable_get(:@stack)).to eq([1])
      end
    end

    describe '`' do
      it 'pops 2 values then pushes 1' do
        @bfi.instance_variable_set(:@stack, [50, 20])
        @bfi.operate!('`')
        expect(@bfi.instance_variable_get(:@stack)).to eq([1])
      end

      it 'pops 2 vaules then pushes 0' do
        @bfi.instance_variable_set(:@stack, [20, 50])
        @bfi.operate!('`')
        expect(@bfi.instance_variable_get(:@stack)).to eq([0])
      end
    end

    describe '?' do
      it 'sets pointer#direction' do
        @bfi.operate!('?')
        expect(@pointer).to have_received(:direction=)
      end
    end

    describe '_' do
      it 'pops and sends the pointer west' do
        @bfi.instance_variable_set(:@stack, [0])
        @bfi.operate!('_')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
        expect(@pointer).to have_received(:direction=).with(:e)
      end

      it 'pops and sends the pointer east' do
        @bfi.instance_variable_set(:@stack, [1])
        @bfi.operate!('_')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
        expect(@pointer).to have_received(:direction=).with(:w)
      end
    end

    describe '|' do
      it 'pops and sends the pointer north' do
        @bfi.instance_variable_set(:@stack, [1])
        @bfi.operate!('|')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
        expect(@pointer).to have_received(:direction=).with(:n)
      end

      it 'pops and sends the pointer south' do
        @bfi.instance_variable_set(:@stack, [0])
        @bfi.operate!('|')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
        expect(@pointer).to have_received(:direction=).with(:s)
      end
    end

    describe ':' do
      it 'duplicates the value on top of the stack' do
        @bfi.instance_variable_set(:@stack, [10])
        @bfi.operate!(':')
        expect(@bfi.instance_variable_get(:@stack)).to eq([10, 10])
      end

      it 'pushes a 0 if the stack is empty' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!(':')
        expect(@bfi.instance_variable_get(:@stack)).to eq([0])
      end
    end

    describe '\\' do
      it 'swaps the values on the top of the stack' do
        @bfi.instance_variable_set(:@stack, [10, 20])
        @bfi.operate!('\\')
        expect(@bfi.instance_variable_get(:@stack)).to eq([20, 10])
      end

      it 'does nothing if there is not >2 items in the stack' do
        @bfi.instance_variable_set(:@stack, [1])
        @bfi.operate!('\\')
        expect(@bfi.instance_variable_get(:@stack)).to eq([1])

        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!('\\')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
      end
    end

    describe '$' do
      it 'pops and discards the top of the stack' do
        @bfi.instance_variable_set(:@stack, [30, 20, 10])
        popped = @bfi.operate!('$')
        expect(@bfi.instance_variable_get(:@stack)).to eq([30, 20])
        expect(popped).to eq(10)
      end

      it 'pops a 0 if the current stack is empty' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        popped = @bfi.operate!('$')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
        expect(popped).to eq(0)
      end
    end

    describe '.' do
      it 'pops and displays the int val' do
        @bfi.instance_variable_set(:@stack, [1, 20])
        expect { @bfi.operate!('.') }.to output('20').to_stdout
        expect(@bfi.instance_variable_get(:@stack)).to eq([1])
      end
    end

    describe ',' do
      it 'pops and displays the ascii val' do
        @bfi.instance_variable_set(:@stack, [1, 97])
        expect { @bfi.operate!(',') }.to output('a').to_stdout
        expect(@bfi.instance_variable_get(:@stack)).to eq([1])
      end

      it 'pops and displays ascii 0 if stack is empty' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        expect{ @bfi.operate!(',') }.to output(0.chr).to_stdout
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
      end
    end

    describe '#' do
      it 'sets the trampoline variable on pointer' do
        @bfi.operate!('#')
        expect(@pointer).to have_received(:trampoline=).with(true)
      end
    end

    describe 'p' do
      it 'pops two values then sets the operation on the map' do
        @bfi.instance_variable_set(:@stack, [35, 5, 3])
        @bfi.operate!('p')
        expect(@code_map).to have_received(:set_operation).with(3, 5, '#')
        expect(@bfi.instance_variable_get(:@stack)).to eq(@empty_stack)
      end
    end

    describe 'g' do
      it 'should push the operation to the stack' do
        @bfi.instance_variable_set(:@stack, [10, 8])
        @bfi.operate!('g')
        expect(@code_map).to have_received(:get_operation_at).with(8, 10)
        expect(@bfi.instance_variable_get(:@stack)).to eq([35])
      end
    end

    describe '&' do
      it 'asks user for number then pushes it' do
        need_input = 'Befunge needs your input for int!'
        expect(STDOUT).to receive(:puts).with(need_input)
        allow(STDIN).to receive(:gets) { "9\n" }
        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!('&')
        expect(@bfi.instance_variable_get(:@stack)).to eq([9])
      end

      it 'raises error when an int is not inputed' do
        @bfi.instance_variable_set(:@stack, @empty_stack)
        allow(STDIN).to receive(:gets) { "bitch" }
        expect{ @bfi.operate!('&') }.to raise_error
      end
    end

    describe '~' do
      it 'asks user for char then pushes its ascii value' do
        need_input = 'Befunge needs your input for char!'
        expect(STDOUT).to receive(:puts).with(need_input)
        allow(STDIN).to receive(:gets) { "a\n" }
        @bfi.instance_variable_set(:@stack, @empty_stack)
        @bfi.operate!('~')
        expect(@bfi.instance_variable_get(:@stack)).to eq([97])
      end

      it 'raises an error if incorrect input is given' do
        allow(STDIN).to receive(:gets) { "bitch" }
        @bfi.instance_variable_set(:@stack, @empty_stack)
        expect{ @bfi.operate!('~') }.to raise_error
      end
    end

    describe '@' do
      it 'ends the program' do
        @bfi.operate!('@')
        expect(@bfi.instance_variable_get(:@computing)).to eq(false)
      end
    end
  end
end
