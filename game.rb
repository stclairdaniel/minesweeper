require_relative 'board'
require 'yaml'

class Game

  def initialize(board)
    @board = board

    @board.populate
    @board.place_mines
    @board.calc_values
  end

  def welcome
    puts 'Welcome to Minesweeper. I haven\'t built a GUI yet, so'
    puts 'enter your row, col, and click or flag as c or f'
    puts 'Example: 3 3 c to click at row 3 column 3'
  end

  def get_input
    input = nil
    until valid_input?(input)
      puts 'Input row col c/f '
      puts 'Type save to save your game'
      puts 'Type load to load a saved game (must be named saved_game.txt)'
      p '=>'
      input = gets.chomp.split(' ')
    end
    input
  end

  def valid_input?(input)
    return true if input == ['save'] || input == ['load']
    return false if input.nil? || input.size != 3
    row, col, click_flag = input
    return false unless row.to_i.between?(0, @board.size - 1)
    return false unless col.to_i.between?(0, @board.size - 1)
    return false unless click_flag == 'c' || click_flag == 'f'
    true
  end

  def click(row,col)
    tile = @board[row,col]
    tile.revealed = true unless tile.flagged
    return if tile.mine
    if tile.value == 0
      @board.get_neighbors(row,col).each do |neighbor|
        unless @board[neighbor[0], neighbor[1]].revealed
          click(neighbor[0], neighbor[1])
        end
      end
    end
  end

  def update(input)
    if input == ['save']
      save
      return
    end
    if input == ['load']
      load
      return
    end
    row, col, click_flag = input
    row = row.to_i
    col = col.to_i
    click(row,col) if click_flag == "c"
    if click_flag == "f"
      if @board[row,col].flagged == true
        @board[row,col].flagged = false
      else
        @board[row,col].flagged = true
      end
    end
  end

  def play
    welcome
    @board.render
    until @board.won? || @board.lost?
      update(get_input)
      @board.render
      puts 'Oh no, you lost!' if @board.lost?
    end
  end

  def save
    puts "ran save"
    File.open('saved_game.txt', 'w') { |file| file.write(self.to_yaml)}
  end

  def load
    puts "ran load"
    game_file = File.open('saved_game.txt', 'r') { |file| file.read}
    game = YAML::load(game_file)
    game.play
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(Board.new)
  game.play
end
