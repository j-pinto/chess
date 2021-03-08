class CastleMove < Move
  attr_reader :king, :rook
  def initialize(move_type_selector, board)
    super
    @king = move_type_selector.piece
    @rook = assign_rook()
  end

  def assign_rook()
    rook_location = nil

    if   ( @finish == [6,0] )
      rook_location = [7,0]

    elsif( @finish == [6,7] )
      rook_location = [7,7]

    elsif( @finish == [2,0] )
      rook_location = [0,0]

    elsif( @finish == [2,7] )
      rook_location = [0,7]
    end

    rook = @board.get_piece(rook_location)
    return rook
  end
end