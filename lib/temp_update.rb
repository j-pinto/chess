class TemporaryUpdate
  attr_reader :move, :board, :captured_piece
  def initialize(move)
    @move = move
    @board = move.board
    @captured_piece = nil
  end

  def execute
    if @move.is_a?(StandardMove)
      @board.grid[@move.finish] = @board.grid[@move.start]
      @board.grid[@move.start] = nil
    elsif @move.is_a?(CaptureMove)
      @captured_piece = @board.grid[@move.finish]
      @board.grid[@move.finish] = @board.grid[@move.start]
      @board.grid[@move.start] = nil
    end
  end

  def revert
    if @move.is_a?(StandardMove)
      @board.grid[@move.start] = @board.grid[@move.finish]
      @board.grid[@move.finish] = nil
    elsif @move.is_a?(CaptureMove)
      @board.grid[@move.start] = @board.grid[@move.finish] 
      @board.grid[@move.finish] = @captured_piece
    end
  end
end