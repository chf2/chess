class SlidingPiece < Piece
  def moves
    possible_moves = []
    get_directions.each do |dir|
      possible_moves += slide(dir)
    end
    possible_moves
  end

  def slide(dir)
    current_pos = @pos.dup
    current_pos
    possible_moves = []
    current_pos = get_new_position(current_pos, dir)

    while @board.in_bounds?(current_pos)
      if @board[current_pos]
        possible_moves << current_pos if @board.is_opponent?(current_pos, color)
        return possible_moves
      else
        possible_moves << current_pos.dup
      end
      current_pos = get_new_position(current_pos, dir)
    end

    possible_moves
  end

  def get_new_position(pos, dir)
    new_position = []
    new_position << pos[0] + dir[0]
    new_position << pos[1] + dir[1]
  end

  def get_directions
    raise "not implemented"
  end
end
