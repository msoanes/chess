require_relative 'errors'

class HumanPlayer
  attr_reader :color
  def initialize(board, color)
    @board = board
    @color = color
  end

  def make_move
    begin
      move = get_input
    rescue InvalidInputError => e
      puts e.message
      retry
    end
  end

  def get_move
    print "> "
    input = gets.chomp
    if input =~ /^[a-h][1-8] [a-h][1-8]$/
      return input.split.map { |coord| input_to_coordinate(coord) }
    end
    input.to_sym
  end

  def input_to_coordinate(code)
    letter, number = code.split('')
    row = 8 - number.to_i
    col = ('a'..'h').to_a.index(letter)

    if [row, col].any? { |coord| coord.nil? || !coord.between?(0, 7) }
      raise InvalidInputError.new("Invalid coordinates")
    end

    [row, col]
  end
end
