require_relative 'errors'

class HumanPlayer
  attr_reader :color
  def initialize(board, color)
    @board = board
    @color = color
  end

  def get_move
    print "> "
    input = gets.chomp
    if input =~ /^[a-h][1-8] [a-h][1-8]$/
      return input.split.map { |coord| input_to_coordinate(coord) }
    end
    input.split.map(&:to_sym)
  end


  private

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
