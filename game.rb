require_relative "chess_loader.rb"

class ChessGame
  def initialize(white = Player.new, black = Player.new)
    @board = Board.new
    @board.place_new_pieces
    @white_p, @black_p = white, black
  end

  def play
    @turn = :white
    until over?
      @board.display
      take_turn
    end
  end

  def take_turn
    if turn == :white
      move = @white_p.get_input(@board.deep_dup, turn)
    else
      move = @black_p.get_input(@board.deep_dup, turn)
    end
    @board.move(*move)
  rescue RuntimeError => e
    puts e
    retry
  end
