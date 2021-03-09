class TemporaryUpdate
  attr_reader :move
  def initialize(move)
    @move = move
  end

  def execute
    if @move.is_a?(StandardMove)
      @move.board.grid[@move.finish] = @move.board.grid[@move.start]
      @move.board.grid[@move.start] = nil
    end
  end

  def revert
    if @move.is_a?(StandardMove)
      @move.board.grid[@move.start] = @move.board.grid[@move.finish]
      @move.board.grid[@move.finish] = nil
    end
  end
end