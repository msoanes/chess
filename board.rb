require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'pawn'

class Board
  LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

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
    8.times do |column|
      @pieces << Pawn.new(self, [1, column], :black)
      @pieces << Pawn.new(self, [6, column], :white)
      @pieces << LAYOUT[column].new(self, [0, column], :black)
      @pieces << LAYOUT[column].new(self, [7, column], :white)
    end

    @pieces.each do |piece|
      self[piece.pos] = piece
    end
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def piece_at(pos)
    @grid[pos.first][pos.last]
  end

  def move(start_pos, end_pos)
    piece = piece_at(start_pos)
    raise "Invalid move" unless piece.valid_moves.include?(end_pos)
    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def checkmate?(color)
    in_check?(color) && get_pieces_of(color).any? do |piece|
      piece.valid_moves.length > 0
    end
  end

  def in_check?(color)
    our_pieces = get_pieces_of(color)
    other_pieces = @pieces - our_pieces

    king_pos = our_pieces.select { |piece| piece.is_a?(King) }[0].pos

    other_pieces.any? { |piece| piece.moves.include?(king_pos) }
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
