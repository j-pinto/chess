class TemporaryUpdate
  attr_reader :move, :board
  def initialize(move)
    @move = move
    @board = move.board
  end

  def execute
    if @move.is_a?(StandardMove)
      @board.grid[@move.finish] = @board.grid[@move.start]
      @board.grid[@move.start] = nil
    end
  end

  def revert
    if @move.is_a?(StandardMove)
      @board.grid[@move.start] = @board.grid[@move.finish]
      @board.grid[@move.finish] = nil
    end
  end
end