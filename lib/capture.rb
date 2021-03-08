class CaptureMove < Move
  attr_reader :captured_piece
  def initialize(move_type_selector, board)
    super

    @captured_piece = board.get_piece(move_type_selector.finish)
  end
end