class Board
  STARTING_POSITIONS = [:rook, :knight, :bishop, :queen, :king, :bishop,
                          :knight, :rook]
  COORDS_MAP = {
                'a' => 0,
                'b' => 1,
                'c' => 2,
                'd' => 3,
                'e' => 4,
                'f' => 5,
                'g' => 6,
                'h' => 7
  }

  attr_accessor :cursor, :cursor_display_piece

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    @captured_pieces = {
      black: [],
      white: []
    }
    @pieces = []

  end

  def capture_at(pos)
    return if self[pos].nil?

    captured_piece = self[pos]
    @captured_pieces[captured_piece.color] << captured_piece
    captured_piece.pos = nil
  end


  def castle(color)
    raise IllegalMoveError.new "Can't castle" unless castle_eligible?(color)

    y = (color == :white) ? 7 : 0
    move!([y,4], [y, 6])
    move!([y,7], [y, 5])
  end

  def castle_eligible?(color)
    return false if in_check?(color)
    king = remaining_pieces.find do |piece|
      piece.color == color && piece.is_a?(King)
    end
    y = (color == :white) ? 7 : 0
    rook = self[[y,7]]
    return false if rook.nil? || rook.moved? || king.moved?
    intervening = [[y,5],[y,6]]
    intervening.none? { |pos| self[pos] || pos_in_check?(color, pos) }
  end

  def check_pawn_promotion
    back_lines = @grid[0] + @grid[7]
    pawns = back_lines.select { |piece| piece.is_a?(Pawn) }
    return nil if pawns.empty?
    pawns
  end

  def checkmate?(color)
    return false unless in_check?(color)
    mate?(color)
  end

  def mate?(color)
    remaining_pieces.select { |piece| piece.color == color }
                    .all? { |piece| piece.valid_moves.empty? }
  end

  def display
    puts "     a   b   c   d   e   f   g   h"
    @grid.each_with_index do |row, row_idx|
      print " #{8-row_idx}  "
      row.each_with_index do |piece, col_idx|
        render = " "
        if @cursor_display_piece && cursor == [row_idx, col_idx]
          render += @cursor_display_piece.colorize(:blue)
        elsif piece.nil?
          render += " "
        elsif piece.color == :black
          render += piece.display.colorize(:red)
        else
          render += piece.display
        end
        render += "  "
        background = (row_idx+col_idx).even? ? :light_cyan : :black
        background = :light_green if @cursor == [row_idx, col_idx]
        print render.colorize(:background => background)
      end
      print "  #{8-row_idx}"
      print "\n"
    end
    puts "     a   b   c   d   e   f   g   h"

    nil
  end

  def deep_dup
    new_board = Board.new
    remaining_pieces.each do |piece|
      new_piece = piece.deep_dup(new_board)
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

  def in_check?(color)
    king = remaining_pieces.find do |piece|
      piece.color == color && piece.is_a?(King)
    end
    pos_in_check?(color, king.pos)
  end

  def pos_in_check?(color, pos)
    remaining_pieces.each do |piece|
      next if piece.color == color
      return true if piece.moves.include?(pos)
    end
    false
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

  def move(start, move_to)
    piece = self[start]
    unless in_bounds?(start)
      raise IllegalMoveError.new "Location not on board"
    end
    unless piece.moves.include?(move_to)
      raise IllegalMoveError.new "Illegal Move"
    end
    if piece.move_into_check?(move_to)
      raise IllegalMoveError.new "Can't Move into Check"
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

  def parse(chess_coord)
    x, y = chess_coord.split('')
    x_coord = COORDS_MAP[x]
    y_coord = 8 - Integer(y)
    [y_coord, x_coord]
  end

  def place_new_piece(pos, piece, color)
    self[pos] = Piece.send(piece, self, pos, color)
    @pieces << self[pos]
  end

  def place_starting_pieces
    place_by_color(STARTING_POSITIONS, :white)
    place_by_color(STARTING_POSITIONS, :black)
  end

  def [](pos)
    return nil unless in_bounds?(pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos, contents)
    y, x = pos
    @grid[y][x] = contents
  end

  protected
  attr_accessor :pieces, :captured_pieces

  private

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

  def remaining_pieces
    @pieces - @captured_pieces[:black] - @captured_pieces[:white]
  end
end
