class Piece
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def moves
    raise "Not yet implemented"
  end

  def valid_position?(position)
    return false unless position.all? { |coord| coord.between?(0,7) }

    piece_at_position = @board[position]
    if piece_at_position.nil?
      true
    else
      piece_at_position.color != @color
    end
  end
end
