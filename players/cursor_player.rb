class CursorPlayer < Player

  private

  def get_move(board)
    board.cursor = [7,0]
    move = []
    until move.size == 2
      return :castle if move.include?(:castle)
      return :save if move.include?(:save)
      system('clear')
      board.display
      puts "It's #{@color}'s turn."
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

  def get_cursor_input(board, first_move)
    char = $stdin.getch
    unless char =~ /[wasdxc\.]/
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
    when 'c'
      return nil unless board.castle_eligible?(@color)
      return :castle
    when '.'
      return nil if !board.is_same_color?(board.cursor, @color) && first_move
      board.cursor_display_piece = board[board.cursor].display
      return board.cursor.dup
    when 'x'
      return :save
    end

    nil
  end
end
