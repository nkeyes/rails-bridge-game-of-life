
# Game.new(width: 10, height: 10, fermi: 0.25)

class Game

  attr_accessor :width, :height, :fermi, :board

  def initialize(width:, height:, fermi:)
    @width = width
    @height = height
    @fermi = fermi
    @rng = Random.new
    @board = Array.new(height) do |y|
      Array.new(width) do |x|
        Cell.new(x: x, y: y, alive: @rng.rand < @fermi)
      end
    end
  end

  def start
    @running = true
    while @running do
      iterate!
      sleep 0.1
    end
  end


  def iterate!
    system("clear")

    (0..@board.length).each { |r| print format('%02d', r) }
    print "\n"

    @board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        calculate_cell cell
      end
    end

    @board.each_with_index do |row, x|
      print x
      row.each_with_index do |cell, y|
        cell.iterate!
        print " #{cell.to_s}"
      end
      print "\n"

    end
  end

  def calculate_cell(cell)
    all_neighbors = get_neighbors(cell)

    alive_neighbor_count = all_neighbors.count(&:alive?)

    if alive_neighbor_count == 3
      cell.pending_state = true
    elsif alive_neighbor_count == 2 && cell.alive?
      cell.pending_state = true
    else
      cell.pending_state = false
    end

    alive_neighbor_count
  end

  def get_neighbors(cell)
    neighbors = []

    (-1..1).each do |y|
      (-1..1).each do |x|
        next if x == 0 && y == 0

        x_pos = (cell.x + x) % @board.length
        y_pos = (cell.y + y) % @board[x].length
        neighbors << @board[x_pos][y_pos]
      end
    end

    neighbors
  end
end

class Cell

  attr_accessor :pending_state, :x, :y

  def initialize(x:, y:, alive:)
    @alive = alive
    @x = x
    @y = y
  end

  def to_s
    @alive ? '#' : ' '
  end

  def iterate!
    if !@pending_state.nil?
      @alive = @pending_state
      @pending_state = nil
    end

  end

  def alive?
    !!@alive
  end

end


game = Game.new(width: 30, height: 30, fermi: 0.25)
game.start

