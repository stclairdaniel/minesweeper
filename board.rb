require_relative 'tile.rb'

class Board
  attr_reader :grid, :size

  def initialize(size = 9)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row,col,tile)
    @grid[row][col] = tile
  end

  def render
    puts "\n"
    (0...@size).each do |row|
      line = []
      (0...@size).each do |col|
        line << "#{self[row,col].to_s}"
      end
      puts line.join(" ")
    end
    puts "\n"
  end

  def mine_placement(num_mines)
    possible = []
    (0...@size).each do |row|
      (0...@size).each do |col|
        possible << [row, col]
      end
    end
    possible.sample(num_mines)
  end

  def place_mines
    #magic number - 10 is classic minesweeper num mines
    mine_placement(10).each do |row, col|
      self[row,col] = Tile.new(true)
    end
  end

  def populate
    (0...@size).each do |row|
      (0...@size).each do |col|
        self[row,col] = Tile.new
      end
    end
  end

  def get_neighbors(row, col)
    #return an array of all neighboring positions on a 2-D array
    neighbors = []

    (-1..1).each do |plus_row|
      (-1..1).each do |plus_col|
        next if plus_row == 0 and plus_col == 0
        neighbors << [row + plus_row, col + plus_col]
      end
    end
    #ensure edges return only neighbors within array
    neighbors.select do |neighbor|
      neighbor[0].between?(0, @size - 1) && neighbor[1].between?(0, @size - 1)
    end

  end

  def calc_value(row, col)
    value = 0
    neighbors = get_neighbors(row, col)
    neighbors.each do |neighbor|
      value += 1 if self[neighbor[0], neighbor[1]].mine
    end
    value
  end

  def calc_values
    (0...@size).each do |row|
      (0...@size).each do |col|
        self[row,col].value = calc_value(row, col)
      end
    end
  end

  #needs testing
  def won?
    (0...@size).each do |row|
      (0...@size).each do |col|
        tile = self[row,col]
        return false unless tile.revealed || tile.mine
      end
    end
    puts "Congratulations! You won!"
    true
  end

  def lost?
    (0...@size).each do |row|
      (0...@size).each do |col|
        tile = self[row,col]
        return true if tile.mine && tile.revealed
      end
    end
    false
  end

end
