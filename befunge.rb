#!/usr/bin/ruby

require './lib/operations.rb'
require './lib/code_map.rb'
require './lib/position.rb'
require './lib/pointer.rb'
require './lib/stack.rb'
require 'colorize'

# This is the top-level class containing everything needed to interpret
# befunge code. Intialize with a string location of a filename and an array
# of flags and then call BefungeInterpreter#interpret. This will run the
# befunge code.
# TODO: Implement flags - debugging mode, animation mode.
class BefungeInterpreter
  include Operations

  def initialize(file, flags)
    @code_map = CodeMap.new(file)
    @flags = flags
    @stack = Stack.new
    @string_mode = false
    @computing = true
    @return_string = ''
  end

  def interpret
    operate_and_step while @computing
  end

  private

  def operate_and_step
    operate!(@code_map.get_operation)
    @code_map.pointer.step
  end

  def print_status
    system 'clear'
    @code_map.print_map
    print_stack
    print_return_string
  end

  def print_stack
    print_whole_stack if @stack.length <= 10
    print_top_ten_stack if @stack.length > 10
  end

  def print_whole_stack
    p @stack
  end

  def print_top_ten_stack
    puts "Showing top ten items on stack..."
    @stack[-11..-1].each { |stack_item| print ", #{stack_item}" }
    print "]\n"
  end

  def print_return_string
    p @return_string
  end
end

# Use this class for debugger mode
class BefungeInterpreterDebugger < BefungeInterpreter
  def interpret
    print_status
    while @computing
      puts "\nDebugger Mode!~"
      puts 'Commands: n = next([, step_amt]), p = put_operation(x, y, op)'
      user_input = $stdin.gets.chomp
      case user_input
      when /\An\z/ then operate_and_step
      when /\An \d+\z/ then operate_and_step(Integer(user_input[2..-1]))
      when /\A(\d+)n/ then operate_and_step(Integer(user_input.match(/(\d+)/)[1]))
      when /\Aquit\z/ then @computing = false
      end
      print_status
    end
  end

  def operate_and_step(n = 1)
    n.times { super() }
  end
end

# Use this class for animation mode
class BefungeInterpreterAnimation < BefungeInterpreter
  def interpret
    print_status
    while @computing
      sleep 0.1
      operate_and_step
      print_status
    end
  end
end

# TODO: animation mode, and debugging mode
AVAILABLE_FLAGS = %w(-d -a)

if __FILE__ == $PROGRAM_NAME
  filename = ARGV[0]
  flags = ARGV[1..-1]
  flags ||= []
  flags.each { |flag| raise 'Fuck you' unless AVAILABLE_FLAGS.include?(flag) }

  if flags.include?('-a')
    klass = BefungeInterpreterAnimation
  elsif flags.include?('-d')
    klass = BefungeInterpreterDebugger
  else
    klass = BefungeInterpreter
  end

  klass.new(filename, flags).interpret
end
