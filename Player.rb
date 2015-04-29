class Player

  def get_input(board, turn)
    puts "It's #{turn}'s turn."
    puts "Make a move (for example, 'f2, f4')"
  begin
    move = gets.chomp.split(", ")
    start = board.parse(move[0])
    move_to = board.parse(move[1])
    [start, move_to]
  rescue ArgumentError
    puts "Please enter valid coordinates:"
    retry
  end

end
