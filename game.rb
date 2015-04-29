require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @board.set_up_pieces
  end

  def run
    current_player = :white
    until @board.no_valid_moves?(current_player)
      @board.render
      move(current_player)
      current_player = switch(current_player)
    end
    game_over
  end

  def move(current_player)
    begin
      puts "It is #{current_player}'s turn."
      print '> '
      positions = gets.chomp.split(/[ ]+/).map { |pos| transform(pos) }
      start_pos, end_pos = positions
      raise unless @board.piece_at(start_pos).color == current_player
      @board.move(start_pos, end_pos)
    rescue
      puts "Please ensure blah blah whatever"
      retry
    end
  end

  def transform(code)
    letter, number = code.split('')
    number = 8 - number.to_i
    letter = ('a'..'h').to_a.index(letter)
    [number, letter]
  end

  def switch(player)
    player == :white ? :black : :white
  end

  def game_over
    puts "Congrats, #{@board.winner}"
  end
end

game = Game.new
game.run
