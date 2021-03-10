class Game
  attr_accessor :turn_count, :board, :players
  def initialize
    @players = nil
    @board = nil
    @turn_count = 0
  end
end