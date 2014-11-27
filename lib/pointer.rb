# This class is responsible for keeping track of it's location on the
# code map and moving in a direction every iteration.
class Pointer
  attr_accessor :direction, :trampoline
  DIRECTIONS = [:w, :e, :n, :s]
  DIRECTIONS_MAP = Hash[DIRECTIONS.zip(
    [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ])]

  def initialize(direction = :e)
    @direction = direction
    @position = Position.new
    @trampoline = false
  end

  def step
    diff = DIRECTIONS_MAP[@direction]
    multiplier = @trampoline ? 2 : 1
    @position.x += diff.first * multiplier
    @position.y += diff.last * multiplier
    @position.x %= 80
    @position.y %= 20
    @trampoline = false
  end

  def x
    @position.x
  end

  def y
    @position.y
  end

  def x=(arg)
    @position.x = arg
  end

  def y=(arg)
    @position.y = arg
  end
end
