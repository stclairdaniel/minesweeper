class Tile

  attr_accessor :mine, :revealed, :neighbors

  def initialize(mine = false)
    @mine = mine
    @revealed = false
    @flagged = false
    @neighbors = 0
  end

  def to_s
    # not revealed and not flagged: *
    # not revealed and flagged: F
    # revealed and no mine and no value: _
    # revealed and no mine and value: value
    # revealed and mine: X
    #following is temporary
    mine ? "x" : "o"
  end


end
