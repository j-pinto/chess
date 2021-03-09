class TemporaryUpdate
  attr_reader :move, :board, :captured_piece
  def initialize(move)
    @move = move
    @board = move.board
  end

  def execute
    if ( @move.is_a?(StandardMove) || @move.is_a?(CaptureMove) )
      @board.grid[@move.finish] = @move.selected_piece
      @board.grid[@move.start] = nil
    end
  end

  def revert
    if @move.is_a?(StandardMove)
      @board.grid[@move.start] = @move.selected_piece
      @board.grid[@move.finish] = nil
    elsif @move.is_a?(CaptureMove)
      @board.grid[@move.start] = @move.selected_piece 
      @board.grid[@move.finish] = @move.captured_piece
    end
  end
end