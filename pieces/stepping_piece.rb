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
