class Board
  attr_accessor :grid

  def initialize
    @pieces = make_pieces()
    @grid = make_grid()
    populate()
    refresh_piece_data()
  end

  public

  def in_bounds?(square)
    if ( square[0].between?(0, 7) && square[1].between?(0, 7) )
      return true
    else
      return false
    end
  end

  def empty?(square)
    if @grid[square] == nil
      return true
    else
      return false
    end
  end

  def get_piece(square)
    if empty?(square)
      return nil
    else
      piece = @grid[square]
      return piece
    end
  end

  def friendly_occupied?(square, friendly_color)
    if empty?(square)
      return false
    end
    occupying_piece = get_piece(square)
    if occupying_piece.color != friendly_color
      return false
    end 
    return true
  end

  def enemy_occupied?(square, friendly_color)
    if empty?(square)
      return false 
    end
    occupying_piece = get_piece(square)
    if occupying_piece.color == friendly_color
      return false 
    end
    return true
  end

  def threat?(location, color, result_type:'bool')
    bool_result = false
    piece_result = nil
    @grid.each_pair { |square, piece| 
      next if piece == nil
      next if piece.color == color
      if piece.is_a?(Pawn)
        bool_result = piece.reachable_captures.any?(location)
      else
        bool_result = piece.reachable_locations.any?(location)
      end

      if bool_result
        piece_result = piece
      end

      piece_result != nil ? break : next
    }
    if result_type == 'bool'
      return bool_result
    elsif result_type == 'piece'
      return piece_result
    end
  end

  def get_king_location(color)
    @grid.each_pair { |square, piece|
      next if piece == nil

      if ( piece.is_a?(King) && piece.color == color )
        return square
      end
    }
  end

  def refresh_piece_data
    @grid.each_pair { |square, piece|
      next if piece == nil
      piece.location = square
      piece.update_reachable_locations(self)
    }
  end

  private

  def populate
    @pieces.each do |piece|
      location = piece.location
      @grid[location] = piece
    end
  end

  def make_grid
    grid = {}
    half_array = (0..7).to_a
    full_array = half_array.repeated_permutation(2).to_a

    full_array.each { |location| grid[location] = nil }

    return grid
  end

  def make_pieces
    pieces = []
  
    pieces.push(
    Rook.new('white', [0, 0]),
    Rook.new('white', [7, 0]),  
    Rook.new('black', [0, 7]),
    Rook.new('black', [7, 7]),
  
    Bishop.new('white', [2, 0]),
    Bishop.new('white', [5, 0]),  
    Bishop.new('black', [2, 7]),
    Bishop.new('black', [5, 7]),
  
    Knight.new('white', [1, 0]),
    Knight.new('white', [6, 0]),  
    Knight.new('black', [1, 7]),
    Knight.new('black', [6, 7]),
  
    Queen.new('white', [3, 0]),
    King.new('white', [4, 0]),
  
    Queen.new('black', [3, 7]),
    King.new('black', [4, 7])
    )
  
    white_pawn_count = 0
    8.times {
      pieces.push( Pawn.new('white', [white_pawn_count, 1]) )
      white_pawn_count += 1
    }
  
    black_pawn_count = 0
    8.times {
      pieces.push( Pawn.new('black', [black_pawn_count, 6]) )
      black_pawn_count += 1
    }
    
    return pieces
  end
#
end
