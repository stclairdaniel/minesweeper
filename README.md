# Minesweeper

Minesweeper is written in Ruby. It can be run in the terminal with "ruby game.rb"

<img src="http://imgur.com/ZH0iAVw.png" style="width: 300px;height: auto"/>

## How To Play

Enter a move as three space separated arguments - row, column, and c for click or f for flag. To save or load a game, type save or load at any time with an optional -f filename.

## Technical details

Minesweeper uses a recursive function to clear tiles on click. Upon click, it will check if neighboring tiles have already been revealed, and if not, it will reveal them and call click on each, unless the tile has been flagged or has a neighboring bomb.

The save system uses Ruby's file I/O to write the current state of the game to a YAML file. On load, it will recreate the saved game state using YAML::load.

```ruby
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
```

The colorize gem is used while iterating through tiles to create a pleasing and easy to read output.
