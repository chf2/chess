class Knight < SteppingPiece
  STEPS = [
    [1,   2],
    [2,   1],
    [2,  -1],
    [1,  -2],
    [-1, -2],
    [-2, -1],
    [-2,  1],
    [-1,  2],
  ]

  def initialize(board, pos, color)
    super
    @display = "♘"
  end

  def get_steps
    STEPS
  end
end
