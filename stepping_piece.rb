require_relative 'piece'

class SteppingPiece < Piece
  def moves
    moves_array = []
    hops.each do |direction|
      new_position = single_step(@pos, direction)
      moves_array << new_position if valid_position?(new_position)
    end
    moves_array
  end
end

class Knight < SteppingPiece
  HOPS = [[1, 2],
          [1, -2],
          [-1, 2],
          [-1, -2],
          [2, 1],
          [2, -1],
          [-2, 1],
          [-2, -1]]

  def symbol
    '♞ '
  end


  private

  def hops
    HOPS
  end
end

class King < SteppingPiece
  def symbol
    '♚ '
  end


  private

  def hops
    STRAIGHT + DIAGONAL
  end
end
