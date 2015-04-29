require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'pawn'
require_relative 'errors'

class Board
  LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_reader :pieces, :grid

  def initialize
    @pieces = []
    @grid = Array.new(8) { Array.new(8) }
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

  def over?
    checkmate?(:white) || checkmate?(:black) || stalemate?
  end

  def piece_at(pos)
    @grid[pos.first][pos.last]
  end

  def move(start_pos, end_pos)
    set_piece_at(start_pos, end_pos) do |piece|
      raise InvalidMoveError.new("No piece in starting position") if piece.nil?
      unless piece.valid_moves.include?(end_pos)
        raise InvalidMoveError.new("That piece can't move there")
      end
    end
  end

  def set_piece_at(start_pos, end_pos, &prc)
    piece = piece_at(start_pos)

    if occupied?(end_pos)
      taken_piece = piece_at(end_pos)
      @pieces.delete(taken_piece)
    end

    prc.call(piece) unless prc.nil?

    self[start_pos] = nil
    self[end_pos] = piece
    piece.pos = end_pos
  end

  def stalemate?
    @pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def checkmate?(color)
    in_check?(color) && get_pieces_of(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def in_check?(color)
    king_pos = @pieces.select do |piece|
      piece.is_a?(King) && piece.color == color
    end[0].pos
    get_pieces_of(:white == color ? :black : :white).any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def get_pieces_of(color)
    @pieces.select { |piece| piece.color == color }
  end

  def deep_dup
    new_board = Board.new
    @pieces.each do |piece|
      new_piece = piece.class.new(new_board, piece.pos.dup, piece.color)
      new_board[piece.pos] = new_piece
      new_board.pieces << new_piece
    end

    new_board
  end

  def render
    grid.each_with_index do |row, row_idx|
      row_mapped = row.map.with_index do |el, col_idx|
        sym = el.nil? ? '  ' : el.to_s
        symbol_background = row_idx % 2 == col_idx % 2 ? :white : :black
        sym.send("on_#{symbol_background}")
      end
      puts "#{8-row_idx} #{row_mapped.join('')}"
    end

    puts "  #{('a'..'h').to_a.join(' ')}"
  end
end
