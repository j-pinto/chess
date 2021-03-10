class Update
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

  def valid?
    refresh_threats()
    king_location = get_king_location(@move.current_player.color)

    king_under_threat = location_under_threat?(king_location, @move.current_player.color)

    castle_path_under_threat = false
    if @move.is_a?(CastleMove)
      castle_path_under_threat = location_under_threat?(@move.rook_finish, @move.current_player.color)
    end

    if king_under_threat || castle_path_under_threat
      return false
    else
      return true
    end
  end

  def location_under_threat?(location, color)
    @board.grid.any? { |square, piece| 
      next if piece == nil
      next if piece.color == color
      piece.reachable_locations.any?(location)
    }
  end

  def get_king_location(color)
    @board.grid.each_pair { |square, piece|
      next if piece == nil

      if ( piece.is_a?(King) && piece.color == color )
        return square
      end
    }
  end

  def refresh_threats
    @board.grid.each_value { |piece|
      next if piece == nil
      piece.update_reachable_locations(@board) 
    }
  end
end