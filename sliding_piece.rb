require_relative 'piece'

class SlidingPiece < Piece


  def moves
    moves_array = []
    move_dirs.each do |direction|
      moves_array += slide(direction)
    end
    moves_array
  end

  def slide(dir)
    moves_array
    new_position = single_step(@pos, dir)
    while valid_position?(new_position)
      moves_array << new_position
      new_position = single_step(new_position, dir)
    end

    moves_array
  end
end

class Queen < SlidingPiece
  def move_dirs
    STRAIGHT + DIAGONAL
  end

  def symbol
    'Q'
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL
  end

  def symbol
    'B'
  end
end

class Rook < SlidingPiece
  def move_dirs
    STRAIGHT
  end

  def symbol
    'R'
  end
end
