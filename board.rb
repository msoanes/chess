require_relative 'piece'

class Board
  attr_reader :pieces, :grid

  def initialize
    @pieces = []
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

  def move(start_pos, end_pos)
    piece = piece_at(start_pos)
    if piece.valid_moves.include?(end_pos)
      self[start_pos] = nil
      self[end_pos] = piece
    else
      raise "Invalid move"
    end
  end

  def checkmate?(color)

  end

  def in_check?(color)
    our_pieces = get_pieces_of(color)
    other_pieces = @pieces - our_pieces

    king_pos = our_pieces.select { |piece| piece.is_a?(King) }[0].pos

    other_pieces.any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def get_pieces_of(color)
    @pieces.select { |piece| piece.color == color }
  end

  def deep_dup
    new_board = Board.new
    @pieces.each do |piece|
      new_piece = Piece.new(new_board, piece.pos, piece.color)
      new_board[piece.pos] = new_piece
      new_board.pieces << new_piece
    end

    new_board
  end
end
