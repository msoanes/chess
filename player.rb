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
    row = 8 - number.to_i
    col = ('a'..'h').to_a.index(letter)

    if [col, row].any? { |coord| coord.nil? || !coord.between?(0, 7) }
      raise InvalidInputError.new("Invalid coordinates")
    end
  end

  def display_info
    puts "Black in check" if @board.in_check?(:black)
    puts "White in check" if @board.in_check?(:white)
    puts "Current player: #{@color.capitalize}"
    puts "Enter start and end coordinates (e.g. 'b1 c3')"
  end
end
