class CoordsPlayer < Player

  private
  def get_move(board)
    puts "It's #{@color}'s turn"
    puts "Make a move (for example, 'f2, f4')"
    move = gets.chomp
    unless move =~ /\A[a-h][1-8], [a-h][1-8]\Z/
      raise ArgumentError.new "Invalid Coordinates"
    end
    move = move.split(", ")
    start = board.parse(move[0])
    move_to = board.parse(move[1])
    [start, move_to]
  end
end
