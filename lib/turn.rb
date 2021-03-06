class Turn
  attr_reader :friendly_player, :enemy_player
  def initialize(turn_count, players)
    @friendly_player = nil
    @enemy_player = nil
    assign_players(turn_count, players)
    prompt()
  end

  def assign_players(turn_count, players)
    if turn_count.even?
      @friendly_player = players['white']
      @enemy_player = players['black']
    else
      @friendly_player = players['black']
      @enemy_player = players['white']
    end
  end

  def prompt
    puts "#{@friendly_player.color} to move"
  end
end