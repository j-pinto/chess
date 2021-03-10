class Update
  attr_reader :move, :board, :captured_piece
  def initialize(move)
    @move = move
    @board = move.board
    @captured_piece = nil
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

    refresh_threats()
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

    refresh_threats()
  end

  def valid?
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

  def finalize
    en_pass_status_reset()
    check_status_reset()
    @move.selected_piece.has_moved = true

    if @move.is_a?(CastleMove)
      @move.rook.has_moved = true
    end

    if ( @move.is_a?(CaptureMove) || @move.is_a?(EnPassMove) )
      @captured_piece = @move.captured_piece
    end

    enemy_king_in_check?()
  end

  def location_under_threat?(location, color)
    @board.grid.any? { |square, piece| 
      next if piece == nil
      next if piece.color == color

      if piece.is_a?(Pawn)
        piece.reachable_captures.any?(location)
      else
        piece.reachable_locations.any?(location)
      end
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
    @board.grid.each_pair { |square, piece|
      next if piece = nil

    }

    @board.grid.each_pair { |square, piece|
      next if piece == nil
      piece.location = square
      piece.update_reachable_locations(@board) 
    }
  end

  def enemy_king_in_check(current_player_color)
    enemy_color = nil
    @move.current_player.color == white ? enemy_color = 'black' : enemy_color = 'white'

    enemy_king_location = get_king_location(enemy_color)
    enemy_king_under_threat = location_under_threat?(enemy_king_location, enemy_color)
    if enemy_king_under_threat
      @board.grid[enemy_king_location].in_check = true
    end
  end

  def check_status_reset
    king_location = get_king_location(@move.current_player.color)
    @board.grid[king_location].in_check = false
  end

  def en_pass_status_reset
    @board.grid.each_pair { |square, piece|
      next if piece == nil
      next if piece == @move.current_player.color
      if piece.is_a?(Pawn)
        piece.en_pass_vulnerable = false
      end
    }
  end
end