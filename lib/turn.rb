class Turn
  attr_accessor :input
  attr_reader :board, :current_player, :enemy_player
  def initialize(game)
    @board = game.board
    @current_player = nil
    @enemy_player = nil
    assign_players(game)
    prompt()
    
    @input = nil
  end

  def assign_players(game)
    if game.turn_count.even?
      @current_player = game.players['white']
      @enemy_player = game.players['black']
    else
      @current_player = game.players['black']
      @enemy_player = game.players['white']
    end
  end

  def prompt
    puts "#{@current_player.color} to move"
  end
end