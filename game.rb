require_relative "chess_loader.rb"
require_relative "players/player.rb"
require_relative "board.rb"
require 'colorize'
require 'yaml'

class ChessGame
  def self.load
    game = YAML::load_file('save.yml')
    game.play
  end

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
    @turn ||= :white
    until over?
      system "clear"
      @board.display
      take_turn
      @turn = next_turn
    end
    find_winner
  end

  def promote(pawns)
    pawns.each do |pawn|
      pos = pawn.pos.dup
      player = pawn.white? ? @white_p : @black_p
      promotion = player.get_promotion
      @board.capture_at(pos)
      @board.place_new_piece(pos, promotion, pawn.color)
    end
  end

  def save_and_exit
    File.open('save.yml', 'w') do |f|
      f.puts self.to_yaml
    end
    exit
  end

  def take_turn
    current_player = (@turn == :white ? @white_p : @black_p)
    move = current_player.get_input(@board.deep_dup)
    save_and_exit if move == :save
    if move == :castle
      @board.castle(@turn)
      return
    end
    unless @board.is_same_color?(move[0], @turn)
      raise IllegalMoveError.new "There's no #{@turn} piece there!"
    end

    @board.move(*move)
    pawns = @board.check_pawn_promotion
    promote(pawns) if pawns
  rescue IllegalMoveError => e
    puts e.message
    retry
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Load Game?"
  answer = gets.chomp.downcase
  if answer == 'y' && File.exist?('save.yml')
    ChessGame.load
  else
    game = ChessGame.new(CursorPlayer.new(:white), CursorPlayer.new(:black))
    game.play
  end
end
