class CastleMove < Move
  attr_reader :king, :rook, :rook_start, :rook_finish
  def initialize(move_type_selector, board)
    super
    @player_color = move_type_selector.current_player.color
    @king = move_type_selector.piece
    @rook_data = assign_rook()
    @rook = @rook_data['rook']
    @rook_start = @rook_data['rook_start']
    @rook_finish = @rook_data['rook_finish']
  end

  def assign_rook()
    rook_location = nil
    rook_finish = nil
    rank = nil
    @player_color == 'white' ? rank = 0 : rank = 7

    if   ( @finish == [6,rank] )
      rook_location = [7,rank]
      rook_finish = [5,rank]

    elsif( @finish == [2,rank] )
      rook_location = [0,rank]
      rook_finish = [3,rank]
    end

    rook = @board.get_piece(rook_location)
    rook_start = rook_location
    rook_finish = rook_finish

    rook_data = {
      'rook' => rook,
      'rook_start' => rook_start,
      'rook_finish' => rook_finish
    }
    return rook_data
  end
end