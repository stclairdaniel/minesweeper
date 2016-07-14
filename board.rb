require_relative 'tile.rb'

class Board
  attr_reader :grid

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
    (0...@size).each do |row|
      line = []
      (0...@size).each do |col|
        line << "#{self[row,col].to_s}"
      end
      puts line.join(" ")
    end
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

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.populate
  board.place_mines
  board.render
end
