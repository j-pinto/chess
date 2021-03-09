class TemporaryUpdate
  attr_reader :move, :board, :captured_piece
  def initialize(move)
    @move = move
    @board = move.board
  end

  def execute
    @board.grid[@move.finish] = @move.selected_piece
    @board.grid[@move.start] = nil

    if @move.is_a?(EnPassMove)
      @board.grid[@move.target_location] = nil
    elsif @move.is_a?(CastleMove)
      @board.grid[@move.rook_finish] = @move.rook
      @board.grid[@move.rook_start] = nil
    end
  end

  def revert
    @board.grid[@move.start] = @move.selected_piece
    @board.grid[@move.finish] = nil

    if @move.is_a?(CaptureMove)
      @board.grid[@move.finish] = @move.captured_piece
    elsif @move.is_a?(EnPassMove)
      @board.grid[@move.target_location] = @move.captured_piece
    elsif @move.is_a?(CastleMove)
      @board.grid[@move.rook_finish] = nil
      @board.grid[@move.rook_start] = @move.rook
    end
  end
end