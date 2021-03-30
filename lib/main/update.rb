class Update
  attr_reader :move, :board, :captured_piece, :check_data, :promoted_pawn
  def initialize(move)
    @move = move
    @board = move.board
    @captured_piece = nil
    @promoted_pawn = nil

    @check_data = {
      'in_check' => false,
      'king' => nil,
      'threat' => nil,
    }
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

    @board.refresh_piece_data()
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

    @board.refresh_piece_data()
  end

  def valid?
    color = @move.current_player.color
    king_location = @board.get_king_location(color)
    king_under_threat = @board.threat?(king_location, color)

    castle_path_under_threat = false
    if @move.is_a?(CastleMove)
      color = @move.current_player.color
      castle_path_under_threat = @board.threat?(@move.rook_finish, color)
    end

    if king_under_threat || castle_path_under_threat
      Prompts.invalid_move_check()
      return false
    else
      return true
    end
  end

  def finalize
    check_status_reset()
    en_pass_status_update()
    move_status_update()
    capture_status_update()

    if promotion?()
      promote()
    end

    @board.refresh_piece_data()
    enemy_king_check_scan()
  end

  def enemy_king_check_scan
    enemy_color = nil
    @move.current_player.color == 'white' ? enemy_color = 'black' : enemy_color = 'white'

    enemy_king_location = @board.get_king_location(enemy_color)
    threat = @board.threat?(enemy_king_location, enemy_color, result_type: 'piece')
    if threat != nil
      @board.grid[enemy_king_location].in_check = true
      @check_data['in_check'] = true
      @check_data['king'] = @board.get_piece(enemy_king_location)
      @check_data['threat'] = threat
    end
  end

  def check_status_reset
    color = @move.current_player.color
    king_location = @board.get_king_location(color)
    @board.grid[king_location].in_check = false
  end

  def en_pass_status_update
    if @move.selected_piece.is_a?(Pawn)
      delta_y = ( @move.start[1] - @move.finish[1] ).abs()
      if delta_y == 2
        @move.selected_piece.en_pass_vulnerable = true
      end
    end

    @board.grid.each_pair { |square, piece|
      next if piece == nil
      next if piece.color == @move.current_player.color
      if piece.is_a?(Pawn)
        piece.en_pass_vulnerable = false
      end
    }
  end

  def move_status_update
    @move.selected_piece.has_moved = true

    if @move.is_a?(CastleMove)
      @move.rook.has_moved = true
    end
  end

  def capture_status_update
    if ( @move.is_a?(CaptureMove) || @move.is_a?(EnPassMove) )
      @captured_piece = @move.captured_piece
    end
  end

  def promotion?
    color = @move.current_player.color
    color == 'white' ? rank = 7 : rank = 0
    
    return false unless @move.finish[1] == rank
    return false unless @move.selected_piece.is_a?(Pawn)

    @promoted_pawn = @move.selected_piece
    return true
  end

  def promote
    promotion_input = nil
    Prompts.promotion()
    loop do
      promotion_input = get_promotion()
      break if promotion_valid?(promotion_input)  
    end
    
    promotion_assign(promotion_input)
  end

  def get_promotion
    return gets.chomp.upcase.gsub(/\s+/, "")
  end

  def promotion_valid?(input)
    valid_inputs = ['Q', 'QUEEN', 'ROOK', 'R', 'BISHOP', 'B', 'KNIGHT', 'N']
    if valid_inputs.any?(input)
      return true
    else
      Prompts.invalid_input()
      return false
    end 
  end

  def promotion_assign(input)
    case input
    when 'Q'
      piece = Queen.new(@promoted_pawn.color, @move.finish)
    when 'R'
      piece = Rook.new(@promoted_pawn.color, @move.finish)
    when 'B'
      piece = Bishop.new(@promoted_pawn.color, @move.finish)
    when 'N'
      piece = Knight.new(@promoted_pawn.color, @move.finish)
    end
    Prompts.promotion_complete(piece)
    @board.grid[@move.finish] = piece
  end

end