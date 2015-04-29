class Pawn < Piece
  TRANSPOSES = {
                forward:       [1, 0],
                forward_two:   [2, 0],
                capture_left:  [1,-1],
                capture_right: [1, 1]
  }

  def initialize(board, pos, color)
    super
    @display = "i"
  end


  def moves
    available_moves = TRANSPOSES.dup
    available_moves.each do |key, pos|
      dy, dx = pos
      dy *= -1 if white?
      new_x, new_y = @pos[1] + dx, @pos[0] + dy
      available_moves[key] = [new_y, new_x]
    end

    possible_moves = []

    possible_moves += available_forward_moves(available_moves)
    possible_moves += available_captures(available_moves)

    possible_moves
  end

  private

  def available_forward_moves(available_moves)
    possible_moves = []
    if @board[available_moves[:forward]].nil?
      possible_moves << available_moves[:forward]
      if @board[available_moves[:forward_two]].nil? && !@moved
        possible_moves << available_moves[:forward_two]
      end
    end

    possible_moves
  end

  def available_captures(available_moves)
    possible_moves = []
    if @board.is_opponent?(available_moves[:capture_left], color)
      possible_moves << available_moves[:capture_left]
    end
    if @board.is_opponent?(available_moves[:capture_right], color)
      possible_moves << available_moves[:capture_right]
    end

    possible_moves
  end

end
