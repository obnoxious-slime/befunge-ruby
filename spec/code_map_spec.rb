require 'spec_helper'

describe CodeMap do
  describe 'basic_map' do
    before(:each) { @code_map = CodeMap.new('./spec/test_examples/basic.bf') }
    describe 'initialize' do
      it 'initializes a pointer' do
        expect(@code_map.pointer.class).to eq(Pointer)
      end

      it 'initializes a map' do
        expect(@code_map.map.class).to eq(Array)
        @code_map.map.each do |line|
          expect(line.class).to eq(Array)
        end
      end

      it 'correctly initializes a map to correct specifications' do
        expect(@code_map.map.length).to eq(20)
        @code_map.map.each do |line|
          expect(line.length).to eq(80)
        end
      end
    end
  end

  describe 'complex_map' do
    before(:each) { @code_map = CodeMap.new('./spec/test_examples/complex.bf') }
    describe 'get_operation' do
      it 'gets the correct operation at the pointer' do
        expect(@code_map.get_operation).to eq('7')
      end
    end

    describe 'get_operation_at' do
      it 'gets the operation at the coords' do
        expect(@code_map.get_operation_at(3, 2)).to eq('|')
        expect(@code_map.get_operation_at(2, 6)).to eq('_')
        expect(@code_map.get_operation_at(8, 4)).to eq('9')
        expect(@code_map.get_operation_at(0, 0)).to eq('7')
      end
    end

    describe 'set_operation' do
      it 'sets the operation at the coords' do
        @code_map.set_operation_at(3, 1, '~')
        @code_map.set_operation_at(9, 9, 'p')
        @code_map.set_operation_at(5, 8, '>')

        expect(@code_map.get_operation_at(3, 1)).to eq('~')
        expect(@code_map.get_operation_at(9, 9)).to eq('p')
        expect(@code_map.get_operation_at(5, 8)).to eq('>')
      end
    end
  end
end
