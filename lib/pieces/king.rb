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