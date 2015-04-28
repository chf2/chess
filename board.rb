require_relative "piece.rb"
require_relative "stepping_piece.rb"
require_relative "sliding_piece.rb"

class Board
  STARTING_POSITIONS = [:rook, :knight, :bishop, :queen, :king, :bishop,
                          :knight, :rook]
  def initialize
    @grid = Array.new(8) {Array.new(8)}
    @captured_pieces = {
      black: [],
      white: []
    }
    @pieces = []
  end

  def display
    @grid.each do |row|
      p row.map { |piece| piece.display if piece }
    end

    nil
  end

  def capture_at(pos)
    return if self[pos].nil?

    captured_piece = self[pos]
    @captured_pieces[captured_piece.color] << captured_piece
    captured_piece.pos = nil
  end

  def checkmate?(color)
    return false unless in_check?(color)
    remaining_pieces.select { |piece| piece.color == color }
                    .all? { |piece| piece.valid_moves.empty? }
  end

  def deep_dup
    new_board = Board.new
    remaining_pieces.each do |piece|
      new_piece= piece.deep_dup(new_board)
      new_board[piece.pos] = new_piece
      new_board.pieces << new_piece
    end
    @captured_pieces.each do |color, array|
      array.each do |piece|
        new_piece = piece.deep_dup(new_board)
        new_board.pieces << new_piece
        new_board.captured_pieces[color] << new_piece
      end
    end

    new_board
  end

  def move(start, move_to)
    piece = self[start]
    raise ArgumentError.new "Invalid Start Position" if piece.nil?
    unless piece.moves.include?(move_to)
      raise RuntimeError.new "Illegal Move"
    end
    if piece.move_into_check?(move_to)
      raise RuntimeError.new "Can't Move into Check"
    end

    move!(start, move_to)
  end

  def move!(start, move_to)
    piece = self[start]
    raise ArgumentError.new "Invalid Start Position" if piece.nil?

    capture_at(move_to)
    self[start] = nil
    self[move_to] = piece
    piece.pos = move_to
    piece.moved = true
  end

  def in_check?(color)
    king = remaining_pieces.find do |piece|
      piece.color == color && piece.is_a?(King)
    end
    remaining_pieces.each do |piece|
      next if piece.color == color
      return true if piece.moves.include?(king.pos)
    end

    false
  end

  def place_by_color(positions, color)
    row = color == :white ?  7 : 0
    positions.each_with_index do |piece, col|
      place_new_piece([row, col], piece, color)
    end
    row = color == :white ? 6 : 1
    (0..7).each do |col|
      place_new_piece([row, col], :pawn, color)
    end
  end

  def place_starting_pieces
    place_by_color(STARTING_POSITIONS, :white)
    place_by_color(STARTING_POSITIONS, :black)
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def is_opponent?(pos, color)
    self[pos] && self[pos].color != color
  end

  def is_same_color?(pos, color)
    self[pos] && self[pos].color == color
  end

  def remaining_pieces
    @pieces - @captured_pieces[:black] - @captured_pieces[:white]
  end

  def [](pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos, contents)
    y, x = pos
    @grid[y][x] = contents
  end

  #protected
  attr_accessor :pieces, :captured_pieces

  #private
  def place_new_piece(pos, piece, color)
    self[pos] = Piece.send(piece, self, pos, color)
    @pieces << self[pos]
  end

end
