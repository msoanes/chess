require_relative 'piece'

class Pawn < Piece
  def moves
    y_coord = @color == :white ? -1 : 1
    diagonal = [[y_coord, -1], [y_coord, 1]].map { |dir| single_step(@pos, dir)}
    straight = [[y_coord, 0]]
    straight << [2 * y_coord, 0] unless @moved
    straight.map! { |dir| single_step(@pos, dir)}

    moves_array = straight.select { |move| valid_straight?(move) }
    moves_array + diagonal.select { |move| valid_diagonal?(move) }
  end

  def valid_straight?(move)
    !@board.occupied?(move)
  end

  def valid_diagonal?(move)
    @board.occupied?(move) && @board.piece_at(move).color != @color
  end

  def symbol
    'P'
  end
end
