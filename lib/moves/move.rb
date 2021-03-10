class Move
  attr_reader :board, :current_player, :start, :finish, :selected_piece
  def initialize(turn)
    @board = turn.board
    @current_player = turn.current_player
    @start = turn.input.start
    @finish = turn.input.finish
    @selected_piece = @board.get_piece(@start)
  end
end

class StandardMove < Move
  def initialize(turn)
    super
  end
end