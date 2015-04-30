require 'colorize'

class Piece
  attr_accessor :pos, :moved
  attr_reader :color

  STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @moved = false
  end

  def inspect
    return "#{symbol}".red if @color == :white
    symbol
  end

  def to_s
    symbol_color = :white == color ? :blue : :light_red
    symbol.send(symbol_color)
  end

  def valid_moves
    moves.reject do |move|
      new_board = @board.deep_dup
      new_board.set_piece_at(@pos, move)
      new_board.in_check?(@color)
    end
  end


  private

  def single_step(position, dir)
    position.map.with_index do |coordinate, idx|
      coordinate + dir[idx]
    end
  end

  def valid_position?(position)
    return false unless position.all? { |coord| coord.between?(0,7) }
    return true unless @board.occupied?(position)
    @color != @board.color_at(position)
  end
end
