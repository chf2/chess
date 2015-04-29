class Queen < SlidingPiece
  DIRECTIONS = [
                [-1,-1],
                [-1, 0],
                [-1, 1],
                [0, -1],
                [0, 1],
                [1, -1],
                [1, 0],
                [1, 1]
               ]

  def initialize(board, pos, color)
    super
    @display = "Q"
  end

  def get_directions
    DIRECTIONS
  end

end
