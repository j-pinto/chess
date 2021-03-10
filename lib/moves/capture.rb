class CaptureMove < Move
  attr_reader :captured_piece
  def initialize(turn)
    super

    @captured_piece = @board.get_piece(turn.input.finish)
  end
end