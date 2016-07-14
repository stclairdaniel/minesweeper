require_relative 'board.rb'

class Game

  def initialize(board)
    @board = board
  end

  def welcome
    puts "Welcome to Minesweeper. I haven't built a GUI yet, so..."
    puts "Enter your row, col, and click or flag as c or f"
    puts "Example: 3 3 c to click at row 3 column 3"
  end

  def get_input
    input = nil
    until valid_input?(input)
      puts "Input row col c/f"
       input = gets.chomp.split(" ")
    end
  end

  def valid_input?(input)
    return false if input.nil? || input.size != 3
    row, col, click_flag = input
    puts row, col, click_flag
    return false unless row.to_i.between?(0, @board.size - 1)
    return false unless col.to_i.between?(0, @board.size - 1)
    return false unless click_flag == "c" || click_flag == "f"
    true
  end

  def click(row,col)
  end

  def update(input)
    row, col, click_flag = input
    click(row,col) if click_flag == "c"
    @board[row,col] = f if click_flag == "f"
  end


  def play
    welcome
    until @board.won?
      update(get_input)
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(Board.new)
  game.get_input
end
