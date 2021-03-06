class Turn
  attr_reader :current_player, :enemy_player
  def initialize(turn_count, players)
    @current_player = nil
    @enemy_player = nil
    assign_players(turn_count, players)
    prompt()
  end

  def assign_players(turn_count, players)
    if turn_count.even?
      @current_player = players['white']
      @enemy_player = players['black']
    else
      @current_player = players['black']
      @enemy_player = players['white']
    end
  end

  def prompt
    puts "#{@current_player.color} to move"
  end
end