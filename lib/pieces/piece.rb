class Piece
  attr_reader :location, :color, :moveset, :unicode, :reachable_locations
  attr_accessor :has_moved

  def initialize(color, initial_location)
    @color = color
    @has_moved = false
    @location = initial_location
    @moveset = get_moveset(self)
    @unicode = add_unicode(self)

    @reachable_locations = []
  end

  public 

  def update_reachable_locations(board)
    reachable_locations = []
    @moveset.each do |move|
      square = @location.clone
      7.times {
        square[0] += move[0]
        square[1] += move[1]

        break if board.friendly_occupied?(square, self.color)
        break if !( board.in_bounds?(square) )

        reachable_locations.push(square.clone)
        break if board.enemy_occupied?(square, self.color)
      }
    end

    @reachable_locations = reachable_locations
  end

  private

  def get_moveset(piece)
    if piece.is_a?(Rook)
      moveset = PieceConstants::BASIC_MOVESETS['rook']
    elsif piece.is_a?(Bishop)
      moveset = PieceConstants::BASIC_MOVESETS['bishop']
    elsif piece.is_a?(Knight)
      moveset = PieceConstants::BASIC_MOVESETS['knight']
    elsif piece.is_a?(Queen)
      moveset = PieceConstants::BASIC_MOVESETS['queen']
    elsif piece.is_a?(King)
      moveset = PieceConstants::BASIC_MOVESETS['king']
    elsif ( piece.is_a?(Pawn) && piece.color == 'white' )
      moveset = [[0, 1]]
    elsif ( piece.is_a?(Pawn) && piece.color == 'black' )
      moveset = [[0, -1]]
    end
    
    return moveset
  end

  def add_unicode(piece)
    if ( piece.is_a?(King) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['king white']
    elsif ( piece.is_a?(King) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['king black']
    elsif ( piece.is_a?(Queen) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['queen white']
    elsif ( piece.is_a?(Queen) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['queen black'] 
    elsif ( piece.is_a?(Bishop) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['bishop white']
    elsif ( piece.is_a?(Bishop) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['bishop black']   
    elsif ( piece.is_a?(Knight) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['knight white']
    elsif ( piece.is_a?(Knight) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['knight black']
    elsif ( piece.is_a?(Rook) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['rook white']
    elsif ( piece.is_a?(Rook) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['rook black']
    elsif ( piece.is_a?(Pawn) && piece.color == 'white' )
      unicode = PieceConstants::UTF8_TABLE['pawn white']
    elsif ( piece.is_a?(Pawn) && piece.color == 'black' )
      unicode = PieceConstants::UTF8_TABLE['pawn black']
    end

    return unicode
  end  
end
