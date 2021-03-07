module PieceConstants
  BASIC_MOVESETS = {
    'knight' => [[2,1], [2,-1], [-2,1], [-2,-1], [1,2], [-1,2], [1,-2], [-1,-2]],
    'bishop' => [[1,1], [-1,1], [1,-1], [-1,-1]],
    'rook' => [[0,1], [0,-1], [1,0], [-1,0]],
    'queen' => [[0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,1], [1,-1], [-1,-1]],
    'king' => [[0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,1], [1,-1], [-1,-1]]
  }

  UTF8_TABLE = {
    'king white' =>   "\u265A".white,
    'queen white' => "\u265B".white,
    'rook white' => "\u265C".white,
    'bishop white' => "\u265D".white,
    'knight white' => "\u265E".white,  
    'pawn white' => "\u265F".white,
    'king black' =>   "\u265A".blue,
    'queen black' => "\u265B".blue,
    'rook black' => "\u265C".blue,
    'bishop black' => "\u265D".blue,
    'knight black' => "\u265E".blue,  
    'pawn black' => "\u265F".blue
  }
end