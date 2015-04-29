class Rook < SlidingPiece
  DIRECTIONS = [
                [-1, 0],
                [0, -1],
                [0, 1],
                [1, 0]
               ]

  def initialize(board, pos, color)
    super
    @display = white? ? "♖" : "♜"
  end

  def get_directions
    DIRECTIONS
  end

end
