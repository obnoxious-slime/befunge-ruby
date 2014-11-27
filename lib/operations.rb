# This module is responsible for performing operations. It keeps all logic
# based on opertaions encapsulated. It is meant to be included with the
# top-level BefungeInterpreter.
module Operations
  # Bunch of Constants here.
  # Important thing: %i() defines array of symbols while %w() defines array
  # of strings. The Hash[Array#zip(Array)] pattern I've chosen to employ here
  # simply maps the string/symbol single character representation of the
  # operation to it's actual method name here. For instance:
  # OPERATORS_MAP['!'] => :logical_not
  # We can just #send that symbol in our #operate! method.

  MATH_OPS = %i(+ - * / %)
  DIRECTION_OPS = %i(^ < > v)
  DIRECTIONS = %i(n w e s)
  DIRECTIONS_MAP = Hash[DIRECTION_OPS.zip(DIRECTIONS)]
  OPERATORS = %w(! ` ? _ | : \\ $ . , # p g & ~ @)
  OPERATORS_MAP = Hash[OPERATORS.zip([
    :logical_not, :greater_than, :rand_direction, :left_right,
    :up_down, :duplicate_stack_top, :swap_stack_top,
    :pop_and_discard, :pop_and_display_int, :pop_and_display_char,
    :trampoline, :put_call, :get_call, :get_user_input_int,
    :get_user_input_char, :end_program
  ])]

  def operate!(op)
    string_mode and return if op == '"'
    push_ascii_value(op) and return if @string_mode
    return if op == ' '
    send(op) and return if MATH_OPS.include?(op.to_sym)
    push_num(op) and return if Integer(op) rescue false
    change_dir(op.to_sym) and return if DIRECTION_OPS.include?(op.to_sym)
    send(OPERATORS_MAP[op])
  end

  # Meta. This defines the + - * / % methods in one loop since they're
  # really all the same rpn calculation.
  MATH_OPS.each do |math_op|
    define_method(math_op) do
      a = @stack.pop
      b = @stack.pop
      @stack.push(b.send(math_op, a))
    end
  end

  def push_num(num)
    @stack.push(num.to_i)
  end

  # I call this method two different ways - one with directional operational
  # arguments < > ^ v and one with actual directions :n :e :s :w. This is
  # the reason for the unless statement here.
  def change_dir(op)
    op = DIRECTIONS_MAP[op] unless DIRECTIONS.include?(op)
    @code_map.pointer.direction = op
  end

  def logical_not
    @stack.pop == 0 ? @stack.push(1) : @stack.push(0)
  end

  def greater_than
    a = @stack.pop
    b = @stack.pop
    b > a ? @stack.push(1) : @stack.push(0)
  end

  def rand_direction
    @code_map.pointer.direction = DIRECTIONS.sample
  end

  def left_right
    @stack.pop == 0 ? change_dir(:e) : change_dir(:w)
  end

  def up_down
    @stack.pop == 0 ? change_dir(:s) : change_dir(:n)
  end

  def string_mode
    @string_mode = !@string_mode
    true
  end

  def duplicate_stack_top
    @stack.push(0) and return if @stack.empty?
    @stack.push(@stack.last)
  end

  def swap_stack_top
    return if @stack.length < 2
    @stack[-1], @stack[-2] = @stack[-2], @stack[-1]
  end

  def pop_and_discard
    @stack.pop
  end

  def pop_and_display_int
    display_int = @stack.pop
    @return_string << display_int.to_s
    print display_int
  end

  def pop_and_display_char
    display_char = @stack.pop.chr
    @return_string << display_char
    print display_char
  end

  def trampoline
    @code_map.pointer.trampoline = true
  end

  def put_call
    y = @stack.pop
    x = @stack.pop
    v = @stack.pop
    @code_map.set_operation(y, x, v.chr)
  end

  def get_call
    y = @stack.pop
    x = @stack.pop
    @stack.push(@code_map.get_operation_at(y, x).ord)
  end

  def get_user_input_int
    puts 'Befunge needs your input for int!'
    @stack.push(Integer($stdin.gets.chomp))
  end

  def get_user_input_char
    puts 'Befunge needs your input for char!'
    input = $stdin.gets.chomp
    raise 'Must be a single character' unless input.length == 1
    @stack.push(input.ord)
  end

  def end_program
    @computing = false
  end

  def push_ascii_value(op)
    @stack.push(op.ord)
  end
end
