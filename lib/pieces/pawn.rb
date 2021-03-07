class Pawn < Piece
  attr_reader :capture_moveset
  attr_accessor :en_pass_vulnerable
  def initialize(color, initial_location)
    super
    @en_pass_vulnerable = false
    @capture_moveset = get_pawn_capture_moveset(self)
  end

  def update_reachable_locations(board)
    reachable_locations = []
    move = @moveset[0]
    square = @location.clone
  
    loops_number = self.has_moved ? 1 : 2
    loops_number.times {
      square[0] += move[0]
      square[1] += move[1]
  
      break if board.friendly_occupied?(square, self.color)
      break if !( board.in_bounds?(square) )
  
      reachable_locations.push(square.clone)
      break if board.enemy_occupied?(square, self.color)
    }
  
    @reachable_locations = reachable_locations
  end

  def get_pawn_capture_moveset(pawn)
    if pawn.color == 'white'
      return [[1, 1], [-1, 1]]
    end
  
    if pawn.color == 'black'
      return [[1, -1], [-1, -1]]
    end
  end
end