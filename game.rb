require_relative 'board'

class Game
  def initialize(player_one, player_two)
    @board = Board.new.set_up_pieces
    @player_one, @player_two = player_one, player_two
  end

  def play
    player = player_one
    until @board.over?
      current_player.make_move
      player = switch_player(player)
    end
    @player_one.game_over
    @player_two.game_over
  end

  def switch_player(player)
    player == @player_one ? @player_two : @player_one
  end
end
