class Board
  attr_accessor :grid

  def initialize(pieces)
    @pieces = pieces
    @grid = {}
    make()
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
    if occupying_piece.color != friendly_color.color
      return false
    end 
    #puts "#{square} friendly occupied"
    return true
  end

  def enemy_occupied?(square, friendly_color)
    if empty?(square)
      return false 
    end
    occupying_piece = get_piece(square)
    if occupying_piece.color == current_player.color
      return false 
    end
    #puts "#{square} enemy occupied"
    return true
  end

  private

  def make
    half_array = (0..7).to_a
    full_array = half_array.repeated_permutation(2).to_a

    full_array.each { |location| @grid[location] = nil }

    populate()
  end

  def populate
    @pieces.each do |piece|
      location = piece.location
      @grid[location] = piece
    end
  end
#
end
