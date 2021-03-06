class CastleMove < Move
  attr_reader :king, :rook, :rook_start, :rook_finish
  def initialize(turn)
    super
    @player_color = turn.current_player.color
    @king = @board.get_piece(turn.input.start)
    @rook_data = get_rook_data()
    @rook = @rook_data['rook']
    @rook_start = @rook_data['rook_start']
    @rook_finish = @rook_data['rook_finish']
    @castle_path = @rook_data['rook_finish']
  end

  def get_rook_data()
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