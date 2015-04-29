class Bishop < SlidingPiece
  DIRECTIONS = [
                [-1,-1],
                [-1, 1],
                [1, -1],
                [1, 1]
               ]

  def initialize(board, pos, color)
    super
    @display = "b"
  end

  def get_directions
    DIRECTIONS
  end

end
