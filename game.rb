require_relative "chess_loader.rb"
require_relative "player.rb"
require_relative "board.rb"
require 'colorize'

class ChessGame
  def initialize(white, black)
    @board = Board.new
    @board.place_starting_pieces
    @white_p, @black_p = white, black
  end

  def find_winner
    @board.display
    if @board.checkmate?(:white)
      puts "Black wins!"
    elsif @board.checkmate?(:black)
      puts "White wins!"
    else
      puts "Stalemate!"
    end
  end

  def next_turn
    @turn == :white ? :black : :white
  end

  def over?
    @board.mate?(@turn)
  end

  def play
    @turn = :white
    until over?
      @board.display
      take_turn
      @turn = next_turn
    end
    find_winner
  end

  def take_turn
    if @turn == :white
      move = @white_p.get_input(@board.deep_dup, @turn)
    else
      move = @black_p.get_input(@board.deep_dup, @turn)
    end
    unless @board.is_same_color?(move[0], @turn)
      raise IllegalMoveError.new "There's no #{@turn} piece there!"
    end

    @board.move(*move)
  rescue IllegalMoveError => e
    puts e.message
    retry
  end
end

game = ChessGame.new(Player.new(:white), Player.new(:black))
game.play
