require_relative 'errors'

class HumanPlayer
  def initialize(board, color)
    @board = board
    @color = color
  end

  def make_move
    begin
      @board.render
      display_info
      move = get_input
      @board.move(*move)
    rescue InvalidInputError => e
      puts e.message
      retry
    end
  end

  def get_input
    print "> "
    pair = gets.chomp.split.map { |coord| input_to_coordinate(coord) }
    if !@board.occupied?(pair.first)
      raise InvalidInputError.new("Must select a piece at starting position.")
    elsif @board.color_at(pair.first) != @color
      raise InvalidInputError.new("Cannot move other player's pieces")
    end
    pair
  end

  def input_to_coordinate(code)
    letter, number = code.split('')
    number = 8 - number.to_i
    letter = ('a'..'h').to_a.index(letter)
    [number, letter].each do |coord|
      if coord.nil? || !coord.between?(0, 7)
        raise InvalidInputError.new("Invalid coordinates")
      end
    end
  end

  def display_info
    puts "You're on your own."
  end
end
