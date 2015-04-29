require_relative 'board'
require_relative 'player'
require 'yaml'

class Game
  SAVE_FILE = 'chess_save.yml'
  SPECIALS = [:save, :quit]

  def initialize(player_one, player_two)
    @board = Board.new
    @board.set_up_pieces
    @player_one = player_one.new(@board, :white)
    @player_two = player_two.new(@board, :black)
    @mover = @player_one
  end

  def play
    @quit = false
    until @board.over? || @quit
      begin
        @board.render
        display_info
        action = @mover.get_move
        if SPECIALS.include?(action)
          send(action)
        elsif valid_coords?(action)
          @board.move(*action)
          switch_player
        end
      rescue InvalidInputError => e
        puts e.message
        retry
      end
    end
    exit_game
  end


  private

  def display_info
    puts "Black in check" if @board.in_check?(:black)
    puts "White in check" if @board.in_check?(:white)
    puts "Current player: #{@mover.color.capitalize}"
    puts "Type 'save' to save and 'quit' to quit"
    puts "Enter start and end coordinates (e.g. 'b1 c3')"
  end

  def exit_game
    if @board.over?
      @board.render
      File.delete(SAVE_FILE) if File.exist?(SAVE_FILE)
      puts "Congratulations, #{@board.winner.capitalize}!"
    else
      puts "Quitter"
    end
  end

  def quit
    @quit = true
  end

  def save
    File.open(SAVE_FILE, 'w') { |f| f.puts(self.to_yaml) }
    puts "Game saved."
  end

  def switch_player
    @mover = (@mover == @player_one ? @player_two : @player_one)
  end

  def valid_coords?(coords)
    if !coords.is_a?(Array)
      raise InvalidInputError.new("Follow the coordinate example, please")
    elsif !@board.occupied?(coords.first)
      raise InvalidInputError.new("Must select a piece at starting position.")
    elsif @board.color_at(coords.first) != @mover.color
      raise InvalidInputError.new("Cannot move other player's pieces")
    end
    true
  end
end


if $PROGRAM_NAME == __FILE__
  if File.exist?(Game::SAVE_FILE)
    game = YAML.load_file(Game::SAVE_FILE)
  else
    game = Game.new(HumanPlayer, HumanPlayer)
  end
  game.play
end
