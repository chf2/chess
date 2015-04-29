require 'io/console'

class Player

  def initialize(color)
    @color = color
  end

  def get_input(board, turn)
    puts "It's #{turn}'s turn."
    return move_via_cursor(board)
  rescue ArgumentError => e
    puts e.message
    puts "Please enter valid coordinates:"
    retry
  end

  private

  def get_cursor_input(board, first_move)
    char = $stdin.getch
    unless char =~ /[wasdx\.]/
      raise IllegalMoveError.new
    end
    case char
    when 'w'
      board.cursor[0] -=1 unless board.cursor[0] == 0
    when 'a'
      board.cursor[1] -=1 unless board.cursor[1] == 0
    when 's'
      board.cursor[0] +=1 unless board.cursor[0] == 7
    when 'd'
      board.cursor[1] +=1 unless board.cursor[1] == 7
    when '.'
      return nil if !board.is_same_color?(board.cursor, @color) && first_move
      board.cursor_display_piece = board[board.cursor].display
      return board.cursor.dup
    when 'x'
      exit
    end

    nil
  end

  def move_via_cursor(board)
    board.cursor = [7,0]
    move = []
    until move.size == 2
      system('clear')
      board.display
      begin
        pos = get_cursor_input(board, move.empty?)
        move << pos unless pos.nil?
      rescue IllegalMoveError => e
        retry
      end
    end

    board.cursor_display_piece = nil
    move
  end

  def read_coords(board)
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
