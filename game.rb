require_relative 'board'
require_relative 'player'

class Game
  def initialize(player_one, player_two)
    @board = Board.new
    @board.set_up_pieces
    @player_one = player_one.new(@board, :white)
    @player_two = player_two.new(@board, :black)
  end

  def play
    player = @player_one
    until @board.over?
      player.make_move
      player = switch_player(player)
    end
    @player_one.game_over
    @player_two.game_over
  end

  def switch_player(player)
    player == @player_one ? @player_two : @player_one
  end
end


game = Game.new(HumanPlayer, HumanPlayer)
game.play
