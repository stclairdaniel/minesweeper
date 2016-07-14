class Tile

  attr_accessor :mine, :revealed, :value

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
    #following is temporary
    if @revealed
      if @mine
        "X"
      elsif @value
        "#{value}"
      else
        "_"
      end
    elsif @flagged
      "F"
    else
      "*"
    end
  end


end
