class AIPlayer < Player
  attr_reader :move_chains

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

  PIECE_HASH = {
    'N' => "Knight",
    'R' => "Rook",
    'B' => "Bishop",
    'K' => "King",
    'Q' => "Queen"
  }

  def initialize(color, file_name = "moves.txt")
    super(color)
    @moves = []
    @move_file = parse(file_name)
  end

  #private
  def get_move(board)
    @board = board
    saved_strategy = { move: nil, score: -1}
    @moves << board.last_move
    saved_strategy[:move] = get_file_move
    saved_strategy[:score] = 1 if saved_strategy[:move]
    random_strategy = {move: get_random_move, score: 0}
    saved_strategy[:move] ||= random_strategy[:move]
  end

  def find_move(destination, piece_class)
    piece_to_move = @board.remaining_pieces.find do |piece|
      right_moves = piece.valid_moves.include?(destination)
      right_piece = piece.class.to_s == piece_class
      right_color = piece.color == @color
      right_moves && right_piece && right_color
    end

    piece_to_move.nil? ? nil : [piece_to_move.pos, destination]
  end

  def get_random_move
    pieces = @board.remaining_pieces.select { |piece| piece.color == @color}
    piece = pieces.sample
    [piece.pos, piece.valid_moves.sample]
  end

  def get_file_move
    turn_number = @moves.length

    if turn_number == 1
      #first turn
      @found_chain = @move_chains.find do |chain|
        move_to_check = read_notation(chain[0][0])
        p move_to_check
        p @moves
        right_place = move_to_check[0] == @moves[0][1]
        right_piece = move_to_check[1] == @board[@moves[0][1]].class.to_s
        right_place && right_piece
      end

      @found_chain ||= @move_chains[4]
    end
    destination_and_piece = read_notation(@found_chain[turn_number-1][1])
    return find_move(*destination_and_piece)
    #return best move from the file, if there is one, else nil
  end

  def parse(file_name)
    raw_data = File.readlines(file_name)
    @move_chains = raw_data.map { |line| line.chomp.split(/ ?\d+\./).drop(1)}
    @move_chains.each do |chain|
      chain.map! { |string| string.split(" ")}
    end
  end

  def read_notation(note_string)
    return nil if note_string.nil?
    pos = [8-note_string[-1].to_i, COORDS_MAP[note_string[-2]]]
    return [pos, "Pawn"] if note_string.length == 2
    capture = note_string.include?('x')
    first = note_string[0]
    return [pos, PIECE_HASH[first]] unless capture

    nil
  end



end
