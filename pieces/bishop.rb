class Bishop < SlidingPiece
  DIRECTIONS = [
                [-1,-1],
                [-1, 1],
                [1, -1],
                [1, 1]
               ]

  def initialize(board, pos, color)
    super
    @display = white? ? "♗" : "♝"
  end

  def get_directions
    DIRECTIONS
  end

end
