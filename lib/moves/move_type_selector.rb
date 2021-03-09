class MoveTypeSelector
  attr_reader :start, :finish, :current_player, :piece, :output
  def initialize(turn, input, board)
    @board = board
    @start = input.start
    @finish = input.finish
    @current_player = turn.current_player
    @piece = board.get_piece(@start)
    @output = nil
  end

  def set_output
    unless start_valid?()
      @output = 'INVALID'
    end

    if is_castle?()
      @output = 'CASTLE'
    elsif is_en_pass?()
      @output = 'EN_PASS'
    elsif is_capture?()
      @output = 'CAPTURE'
    elsif is_standard?()
      @output = 'STANDARD'
    else
      @output = 'INVALID'
    end
  end

  def start_valid?
    if @board.friendly_occupied?(@start, @current_player.color)
      return true
    else
      return false 
    end
  end

  def is_castle?
    return false unless @piece.is_a?(King)

    delta_y = ( @start[1] - @finish[1] )
    return false unless delta_y == 0
    delta_x = ( @start[0] - @finish[0] )
    return false unless delta_x.abs() == 2

    castle_ok = false
    if ( (delta_x < 0) && @piece.can_castle_short )
      castle_ok = true
    elsif ( (delta_x > 0) && @piece.can_castle_long )
      castle_ok = true
    end

    return castle_ok
  end

  def is_en_pass?
    return false unless @piece.is_a?(Pawn)
    return false unless @piece.reachable_captures.include?(@finish)
    return false unless @board.empty?(@finish)

    return true
  end

  def is_capture?
    return false unless @board.enemy_occupied?(@finish, @current_player.color)

    if @piece.is_a?(Pawn)
      return false unless @piece.reachable_captures.include?(@finish)
    else
      return false unless @piece.reachable_locations.include?(@finish)
    end

    return true
  end

  def is_standard?
    return false unless @piece.reachable_locations.include?(@finish)

    return true
  end
#  
end