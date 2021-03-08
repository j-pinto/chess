class Move
  attr_reader :start, :finish, :selected_piece
  def initialize(move_type_selector, board)
    @board = board
    @start = move_type_selector.start
    @finish = move_type_selector.finish
    @selected_piece = move_type_selector.piece
  end
end

class StandardMove < Move
  def initialize(move_type_selector, board)
    super
  end
end