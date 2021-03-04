class Game
  attr_reader :board
  def initialize
    @players = make_players()
    @pieces = make_pieces()
    @board = Board.new(@pieces)
  end

  private

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

  def make_players
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    return players
  end
  
#
end