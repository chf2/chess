require 'io/console'

class Player

  def initialize(color)
    @color = color
  end

  def get_input(board)
    return get_move(board)
  rescue ArgumentError => e
    puts e.message
    puts "Please enter valid coordinates:"
    retry
  end

  def get_promotion
    return :queen
  end

  private

  def get_move
    raise NoMethodError.new "Not Implemented"
  end
end
