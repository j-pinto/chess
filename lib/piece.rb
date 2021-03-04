class Piece
  attr_reader :default_position, :color, :moveset, :unicode
  attr_accessor :has_moved

  def initialize(color, default_position=nil)
    @color = color
    @has_moved = false
    @default_position = default_position
    @moveset = get_moveset(self)
    @unicode = add_unicode(self)
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
