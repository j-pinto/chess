class Game
  attr_accessor :turn_count
  attr_reader :board, :players
  def initialize
    @players = make_players()
    @board = Board.new

    @turn_count = 0
  end

  private

  def make_players
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    return players
  end
  
#
end