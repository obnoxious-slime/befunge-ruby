Gem::Specification.new do |s|
  s.name = 'befunge_ruby'
  s.version = '0.0.1'
  s.date = '2014-11-27'
  s.summary = 'Befunge'
  s.description = 'Basic Befunge Interpreter'
  s.authors = ['Obnoxious_Slime']
  s.email = 'Obnoxious_slime@mail.com'
  s.files = %w(lib/befunge_interpreter.rb lib/code_map.rb
    lib/operations.rb lib/pointer.rb lib/stack.rb)
  s.executables = ['befunge_ruby']
  s.license = 'WTFPL'
  s.add_runtime_dependency 'colorize', '~> 0'
end
