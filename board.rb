require_relative 'piece'

class Board
  attr_reader :white_pieces, :black_pieces, :grid

  def initialize
    @white_pieces = []
    @black_pieces = []
    @grid = Array.new { Array.new(8) }
    # set_up_pieces
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def set_up_pieces
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def piece_at(pos)
    @grid[pos.first][pos.last]
  end

  def checkmate?(color)
  end

  def in_check?(color)
    pieces = [@black_pieces, @white_pieces]
    pieces.reverse if color == :white
    our_pieces, other_pieces = pieces

    king_pos = our_pieces.select { |piece| piece.is_a?(King) }[0].pos

    other_pieces.any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def deep_dup
    new_board = Board.new
    @black_pieces.concat(@white_pieces).each do |piece|
      new_piece = Piece.new(new_board, piece.pos, piece.color)
      new_board[piece.pos] = new_piece
      new_board.send("#{piece.color.to_s}_pieces") << new_piece
    end

    new_board
  end
end
