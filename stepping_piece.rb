class SteppingPiece < Piece
  def moves
    possible_moves = []
    get_steps.map { |dy, dx| [dy + @pos[0], dx + @pos[1]] }
             .select {|pos| @board.in_bounds?(pos)}
             .reject {|pos| @board.is_same_color?(pos, color)}
  end

  def get_steps
    raise "not implemented"
  end
end

class King < SteppingPiece
  STEPS = [
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
    @display = "K"
  end

  def get_steps
    STEPS
  end
end

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
    @display = "k"
  end

  def get_steps
    STEPS
  end
end
