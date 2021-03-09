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
    end
  end

  def revert
    @board.grid[@move.start] = @move.selected_piece

    if ( @move.is_a?(StandardMove) || @move.is_a?(EnPassMove) )
      @board.grid[@move.finish] = nil
    end

    if ( @move.is_a?(CaptureMove) && !(@move.is_a?(EnPassMove)) )
      @board.grid[@move.finish] = @move.captured_piece
    elsif @move.is_a?(EnPassMove)
      @board.grid[@move.target_location] = @move.captured_piece
    end
  end
end