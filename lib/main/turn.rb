class Turn
  attr_accessor :input
  attr_reader :board, :current_player, :enemy_player
  def initialize(game)
    @board = game.board
    @current_player = nil
    @enemy_player = nil
    assign_players(game)
    puts "#{prompt()}"
    
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
    if @current_player.color == 'white'
      return "White To Move"
    else
      return "Black To Move"
    end
  end
end