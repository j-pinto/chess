class King < Piece
  attr_accessor :in_check
  def initialize(color, initial_location)
    super
    @in_check = false
  end

  public

  def update_reachable_locations(board)
    reachable_locations = []
    @moveset.each do |move|
      square = @location.clone
      square[0] += move[0]
      square[1] += move[1]

      next if board.friendly_occupied?(square, self.color)
      next if !( board.in_bounds?(square) )

      reachable_locations.push(square.clone)
      next if board.enemy_occupied?(square, self.color)
    end

    @reachable_locations = reachable_locations
  end
end

class Pawn < Piece
  attr_reader :capture_moveset
  attr_accessor :en_pass_vulnerable
  def initialize(color, initial_location)
    super
    @en_pass_vulnerable = false
    @capture_moveset = get_pawn_capture_moveset(self)
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

class Rook < Piece
  def initialize(color, initial_location)
    super
  end
end

class Bishop < Piece
  def initialize(color, initial_location)
    super
  end
end

class Queen < Piece
  def initialize(color, initial_location)
    super
  end
end

class Knight < Piece
  def initialize(color, initial_location)
    super
  end

  public

  def update_reachable_locations(board)
    reachable_locations = []
    @moveset.each do |move|
      square = @location.clone
      square[0] += move[0]
      square[1] += move[1]

      next if board.friendly_occupied?(square, self.color)
      next if !( board.in_bounds?(square) )

      reachable_locations.push(square.clone)
      next if board.enemy_occupied?(square, self.color)
    end

    @reachable_locations = reachable_locations
  end
end