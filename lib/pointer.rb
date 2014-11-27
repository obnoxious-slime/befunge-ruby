# This class is responsible for keeping track of it's location on the
# code map and moving in a direction every iteration.
class Pointer
  attr_accessor :direction, :trampoline, :x, :y
  DIRECTIONS = [:w, :e, :n, :s]
  DIRECTIONS_MAP = Hash[DIRECTIONS.zip(
    [
      [-1, 0], [1, 0], [0, -1], [0, 1]
    ])]

  def initialize(direction = :e)
    @direction = direction
    @x, @y = 0, 0
    @trampoline = false
  end

  def step
    diff = DIRECTIONS_MAP[@direction]
    multiplier = @trampoline ? 2 : 1
    self.x = x + diff.first * multiplier
    self.y = y + diff.last * multiplier
    self.x = x % 80
    self.y = y % 20
    @trampoline = false
  end
end
