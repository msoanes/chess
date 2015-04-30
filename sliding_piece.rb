require_relative 'piece'

class SlidingPiece < Piece
  def moves
    moves_array = []
    move_dirs.each do |direction|
      moves_array += slide(direction)
    end
    moves_array
  end


  private

  def slide(dir)
    moves_array = []
    new_position = single_step(@pos, dir)

    while valid_position?(new_position)
      moves_array << new_position
      prev_position = new_position
      new_position = single_step(new_position, dir)
      break if @board.occupied?(prev_position)
    end

    moves_array
  end
end

class Queen < SlidingPiece
  def symbol
    '♛ '
  end


  private

  def move_dirs
    STRAIGHT + DIAGONAL
  end
end

class Bishop < SlidingPiece
  def symbol
    '♝ '
  end


  private

  def move_dirs
    DIAGONAL
  end
end

class Rook < SlidingPiece
  def symbol
    '♜ '
  end


  private

  def move_dirs
    STRAIGHT
  end
end
