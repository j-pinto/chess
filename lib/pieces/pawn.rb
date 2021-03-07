class Pawn < Piece
  attr_reader :capture_moveset, :reachable_captures
  attr_accessor :en_pass_vulnerable
  def initialize(color, initial_location)
    super
    @en_pass_vulnerable = false
    @capture_moveset = get_pawn_capture_moveset(self)
    @reachable_captures = []
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
  
    update_reachable_captures(board)
    @reachable_locations = reachable_locations
  end

  def update_reachable_captures(board)
    reachable_captures = []
  
    @capture_moveset.each do |move|
      square = @location.clone
      square[0] += move[0]
      square[1] += move[1]
  
      en_pass_square = [square[0], (square[1] - 1)]
  
      next if board.friendly_occupied?(square, self.color)
      next if !( board.in_bounds?(square) )
  
      if board.enemy_occupied?(square, self.color) ||
        en_pass_possible?(en_pass_square, board)
      then
        reachable_captures.push(square.clone)
      end
    end
  
    @reachable_captures = reachable_captures
  end
  
  def en_pass_possible?(square, board)
    return false unless board.enemy_occupied?(square, self.color)
  
    target = board.get_piece(square) 
    return false unless target.is_a?(Pawn)
    return false unless target.en_pass_vulnerable
  
    return true
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