#!/usr/bin/ruby

require './lib/operations.rb'
require './lib/code_map.rb'
require './lib/pointer.rb'
require './lib/stack.rb'
require './lib/befunge_interpreter.rb'
require 'colorize'

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
