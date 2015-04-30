require_relative 'stepping_piece'
require_relative 'sliding_piece'
require_relative 'pawn'
require_relative 'errors'

class Board
  attr_reader :grid
  LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def castle(color, options = {kingside: true})
    # king = pieces.find { |piece| piece.is_a?(King) && piece.color == color }

    base_row = color == :white ? 7 : 0
    rook_col = options[:kingside] ? 7 : 0
    king_col = 4

    king = piece_at([base_row, king_col])
    rook = piece_at([base_row, rook_col])

    old_king_pos = king.pos
    old_rook_pos = [base_row, rook_col]

    new_king_pos = [old_king_pos.first, old_king_pos.last + (options[:kingside] ? 2 : -2)]
    new_rook_pos = [old_king_pos.first, old_king_pos.last + (options[:kingside] ? 1 : -1)]

    if can_castle?(king, rook)
      self[new_king_pos] = king
      self[new_rook_pos] = rook
      king.pos = new_king_pos
      rook.pos = new_rook_pos
    end
  end

  def checkmate?(color)
    in_check?(color) && no_valid_moves?(color)
  end

  def color_at(pos)
    piece_at(pos).color if occupied?(pos)
  end

  def deep_dup
    new_board = Board.new
    pieces.each do |piece|
      new_piece = piece.class.new(new_board, piece.pos.dup, piece.color)
      new_board[piece.pos] = new_piece
    end

    new_board
  end

  def in_check?(color)
    king = pieces.find { |piece| piece.is_a?(King) && piece.color == color }
    get_pieces_of(:white == color ? :black : :white).any? do |piece|
      piece.moves.include?(king.pos)
    end
  end

  def move(start_pos, end_pos)
    set_piece_at(start_pos, end_pos) do |piece|
      if piece.nil?
        raise InvalidMoveError.new("No piece in starting position")
      elsif !piece.valid_moves.include?(end_pos)
        raise InvalidMoveError.new("That piece can't move there")
      end
    end
  end

  def move_to_check?(start_pos, end_pos, color)
    new_board = deep_dup
    new_board.set_piece_at(start_pos, end_pos)
    new_board.in_check?(color)
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

  def render
    grid.each_with_index do |row, row_idx|
      formatted_row = row.map.with_index do |col, col_idx|
        sym = col.nil? ? '  ' : col.to_s
        sym.send("on_#{square_color(row_idx, col_idx)}")
      end
      puts "#{8-row_idx} #{formatted_row.join}"
    end
    puts "  #{('a'..'h').to_a.join(' ')}"
  end

  def set_piece_at(start_pos, end_pos, &prc)
    piece = piece_at(start_pos)
    prc.call(piece) unless prc.nil?
    self[start_pos], self[end_pos] = nil, piece
    piece.pos, piece.moved = end_pos, true
  end

  def set_up_pieces
    8.times do |column|
      self[[1, column]] = Pawn.new(self, [1, column], :black)
      self[[6, column]] = Pawn.new(self, [6, column], :white)
      self[[0, column]] = LAYOUT[column].new(self, [0, column], :black)
      self[[7, column]] = LAYOUT[column].new(self, [7, column], :white)
    end
  end

  def winner
    return :white if checkmate?(:black)
    return :black if checkmate?(:white)
    :nobody
  end


  private

  def can_castle?(king, rook)
    dir = rook.pos[1] > king.pos[1] ? 1 : -1

    cannot_castle = king.moved || rook.moved
    cannot_castle ||= spaces_filled_between?(king.pos, rook.pos)
    cannot_castle ||= moving_through_check?(king, dir)

    if cannot_castle
      raise InvalidMoveError.new("Castling unavailable")
    end

    true
  end

  def get_pieces_of(color)
    pieces.select { |piece| piece.color == color }
  end

  def no_valid_moves?(color)
    get_pieces_of(color).all? { |piece| piece.valid_moves.empty? }
  end

  def moving_through_check?(king, dir)
    1.upto(3) do |distance|
      end_pos  = [king.pos[0], king.pos[1] + dir * distance]
      return true if move_to_check?(king.pos, end_pos, king.color)
    end
    false
  end

  def pieces
    @grid.flatten.compact
  end

  def spaces_filled_between?(start_pos, end_pos)
    endpoints = [start_pos, end_pos].sort
    ((endpoints.first.first + 1)...endpoints.last.first).any? { |col| occupied?([start_pos.first, col]) }
  end

  def square_color(row, col)
    row.even? == col.even? ? :light_white : :white
  end

  def stalemate?
    no_valid_moves?(:black) || no_valid_moves?(:white)
  end
end
