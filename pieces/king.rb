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
    @display = "♔"
  end

  def get_steps
    STEPS
  end
end
