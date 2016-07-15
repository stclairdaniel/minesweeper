require 'colorize'

class Tile

  attr_reader :mine
  attr_accessor :revealed, :value, :flagged

  def initialize(mine = false)
    @mine = mine
    @revealed = false
    @flagged = false
    @value = 0
  end

  def to_s
    # not revealed and not flagged: *
    # not revealed and flagged: F
    # revealed and no mine and no value: _
    # revealed and no mine and value: value
    # revealed and mine: X
    if @revealed
      if @mine
        "X".colorize(:yellow)
      elsif @value
        "#{value}".colorize(:light_green)
      else
        "_"
      end
    elsif @flagged
      "F".colorize(:red)
    else
      "*"
    end
  end

end
