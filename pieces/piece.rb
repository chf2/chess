class Piece
  def self.bishop(board, pos, color)
    Bishop.new(board, pos, color)
  end

  def self.king(board, pos, color)
    King.new(board, pos, color)
  end

  def self.knight(board, pos, color)
    Knight.new(board, pos, color)
  end

  def self.pawn(board, pos, color)
    Pawn.new(board, pos, color)
  end

  def self.queen(board, pos, color)
    Queen.new(board, pos, color)
  end

  def self.rook(board, pos, color)
    Rook.new(board, pos, color)
  end

  attr_reader :color, :display
  attr_accessor :pos, :moved

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    @moved = false
  end

  def deep_dup(new_board)
    new_piece = self.class.new(new_board, @pos.nil? ? nil : @pos.dup, color)
    new_piece.moved = @moved
    new_piece
  end

  def inspect
    {
      class: self.class,
      position: @pos,
      color: @color,
      moved: @moved
    }.inspect
  end

  def moves
    raise "Not implemented"
  end

  def valid_moves
    possible_moves = moves
    possible_moves.reject { |pos| move_into_check?(pos) }
  end

  def move_into_check?(new_pos)
    new_board = @board.deep_dup
    new_board.move!(@pos, new_pos)
    new_board.in_check?(color)
  end

  def white?
    color == :white
  end

  def moved?
    moved
  end

end
