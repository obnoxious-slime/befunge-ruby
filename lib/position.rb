# Generic position class - keeps x and y coords
class Position
  attr_accessor :x, :y
  def initialize(x = 0, y = 0)
    @x, @y = x, y
  end
end
