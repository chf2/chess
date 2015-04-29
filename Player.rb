class Player

  def get_input(board, turn)
    puts "It's #{turn}'s turn."
    puts "Make a move (for example, 'f2, f4')"
    move = gets.chomp
    unless move =~ /\A[a-h][1-8], [a-h][1-8]\Z/
      raise ArgumentError.new "Invalid Coordinates"
    end
    move = move.split(", ")
    start = board.parse(move[0])
    move_to = board.parse(move[1])
    [start, move_to]
  rescue ArgumentError => e
    puts e.message
    puts "Please enter valid coordinates:"
    retry
  end

end
