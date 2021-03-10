class EnPassMove < Move
  attr_reader :target_location, :captured_piece
  def initialize(turn)
    super
    @target_location = assign_target_location()
    @captured_piece = @board.get_piece(@target_location)
  end

  def assign_target_location
    target_x = @finish[0]

    rank_adjust = nil
    @selected_piece.color == 'white' ? rank_adjust = -1 : rank_adjust = 1

    target_y = ( @finish[1] + rank_adjust )

    return [target_x, target_y]
  end
end