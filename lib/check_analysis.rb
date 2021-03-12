class CheckAnalysis
  attr_reader :checkmate
  def initialize(update)
    @board = update.board
    @king = update.check_data['king']
    @threat = update.check_data['threat']
    @check_path = get_check_path()
    @checkmate = get_result()
  end

  def get_result
    if threat_capturable?()
      puts ""
      puts "threat can be captured"
      return false
    end
    unless @check_path.empty?
      @check_path.each { | path_square | 
        if square_blockable?(path_square)
          puts ""
          puts "check can be blocked"
          return false
        end
      }
    end

    if king_moveable?()
      puts ""
      puts "king can escape"
      return false
    end

    puts ""
    puts "checkmate!"
    return true
  end

  def threat_capturable?
    hero_piece = @board.threat?(@threat.location, @threat.color, result_type: 'piece')
    if hero_piece == nil
      return false
    end

    start = hero_piece.location
    finish = @threat.location
    return false if escape_results_in_check?(start, finish)
    return true
  end

  def square_blockable?(path_square)
    @board.grid.each_pair { |square, piece|
      next if piece.is_a?(King)
      next unless @board.friendly_occupied?(square, @king.color)
      if piece.reachable_locations.include?(path_square)
        hero_piece = piece
        start = hero_piece.location
        finish = path_square
        return true unless escape_results_in_check?(start, finish)   
      end
    }
    return false
  end

  def king_moveable?
    @king.reachable_locations.each { |square| 
      start = @king.location
      finish = square
      return true unless escape_results_in_check?(start, finish)
    }
    return false
  end

  def escape_results_in_check?(start, finish)
    temp_storage = nil
    unless @board.empty?(finish)
      temp_storage = @board.get_piece(finish)
    end

    @board.grid[finish] = @board.grid[start]
    @board.grid[start] = nil
    @board.refresh_piece_data()

    threat_result = @board.threat?(@king.location, @king.color)

    @board.grid[start] = @board.grid[finish]
    @board.grid[finish] = temp_storage
    @board.refresh_piece_data()

    return threat_result
  end

  def get_check_path
    path = []
    if ( @threat.is_a?(Pawn) || @threat.is_a?(Knight) )
      return path
    end

    direction = get_direction()
    square = @threat.location.clone
    loop do
      square[0] += direction[0]
      square[1] += direction[1]
      break if square == @king.location
      path.push(square.clone)
    end

    return path
  end

  def get_direction
    delta_x = @king.location[0] - @threat.location[0]
    delta_y = @king.location[1] - @threat.location[1]

    direction_x = nil
    if delta_x == 0
      direction_x = 0
    else
      direction_x = ( delta_x / delta_x.abs() )
    end

    direction_y = nil
    if delta_y == 0
      direction_y = 0
    else
      direction_y = ( delta_y / delta_y.abs() )
    end

    direction = [ direction_x, direction_y ]
    return direction
  end
end