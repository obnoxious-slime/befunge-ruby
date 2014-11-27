# This class is reponsible for keeping the befunge code. It will output
# the current operation the pointer is at, and also set and get operations
# based on coordinates. CodeMap#print_map will be used for animation
# and debuggin modes.
class CodeMap
  attr_reader :width, :height, :pointer, :map
  def initialize(file)
    @pointer = Pointer.new
    @map = File.open(file, 'r').readlines.map { |line| line.chomp.split '' }
    format_code_map
  end

  def get_operation
    @map[@pointer.y][@pointer.x]
  end

  def set_operation_at(x, y, op)
    @map[y][x] = op
  end

  def get_operation_at(x, y)
    @map[y][x]
  end

  def print_map
    system 'clear'
    @map.each_with_index do |line, i|
      line.each_with_index do |char, j|
        if @pointer.x == j && @pointer.y == i
          print char.colorize(background: :red)
        else
          print char
        end
      end

      print "\n"
    end
  end

  private

  def format_code_map
    check_if_valid
    until @map.length == 20
      @map << []
      80.times { @map.last << ' ' }
    end
    @map.each do |line|
      until line.length == 80
        line << ' '
      end
    end
  end

  def check_if_valid
    raise 'Invalid map' unless @map.length <= 80
    @map.each do |line|
      raise 'Invalid map' unless line.length <= 80
    end
  end
end
