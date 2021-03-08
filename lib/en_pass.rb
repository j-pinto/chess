class EnPassMove < CaptureMove
  def initialize(move_type_selector, board)
    super

    target_x = move_type_selector.finish[0]
    target_y = ( move_type_selector.finish[1] - 1 )
    target_location = [target_x, target_y]
    
    @captured_piece = board.get_piece(target_location)
  end
end