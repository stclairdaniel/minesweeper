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
    puts 'Welcome to Minesweeper. Type "help" for commands'
  end

  def help
    puts 'Enter your row, col, and click or flag as c or f'
    puts 'Example: 3 3 c to click at row 3 column 3'
    puts
    puts 'Type save at any time to save your game'
    puts 'Type load at any time to load a saved game'
    puts
    puts 'You can add an optional -f filename to either save or load'
  end

  def get_input
    input = nil
    until valid_input?(input)
      p 'Enter move =>'
      input = gets.chomp.split(' ')
    end
    input
  end

  def valid_input?(input)
    return false if input.nil?
    return true if %w[save load help].include?(input[0])
    return false if input.size != 3
    row, col, click_flag = input
    max = (@board.size - 1).to_s
    return false unless ('0'..max).include?(row) &&
      ('0'..max).include?(row) &&
        click_flag == 'c' || click_flag == 'f'
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

  def update_handler(input)
    if %w[save load help].include?(input[0])
        update_file(input)
    else
      update_board(input)
    end
  end


  def update_board(input)
    row, col, click_flag = input
    row = row.to_i
    col = col.to_i
    click(row,col) if click_flag == 'c'
    if click_flag == 'f'
      if @board[row,col].flagged == true
        @board[row,col].flagged = false
      else
        @board[row,col].flagged = true
      end
    end
  end

  def update_file(input)
    case input[0]
    when 'save'
      save(input)
    when 'load'
      load(input)
    when 'help'
      help
    end
  end

  def play
    welcome
    @board.render
    until @board.won? || @board.lost?
      update_handler(get_input)
      @board.render
      puts 'Oh no, you lost!' if @board.lost?
    end
  end

  def save(input)
    if input.include?('-f')
      filename = input[-1]
    else
      filename = 'saved_game.txt'
    end
    File.open(filename, 'w') { |file| file.write(self.to_yaml)}
    puts 'Game saved'
  end

  def load(input)
    if input.include?('-f')
      filename = input[-1]
    else
      filename = 'saved_game.txt'
    end
    game_file = File.open(filename, 'r') { |file| file.read}
    game = YAML::load(game_file)
    puts 'Game loaded'
    game.play
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(Board.new)
  game.play
end
