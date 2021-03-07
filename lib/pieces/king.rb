class King < Piece
  attr_accessor :in_check
  def initialize(color, initial_location)
    super
    @in_check = false
    @castle_short_available = false
    @castle_long_available = false
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

  def castle_short_available?(board)
    self.color == 'white' ? rank = 0 : rank = 7
    return false unless board.empty?( [5, rank] )
    return false unless board.empty?( [6, rank] )

    partner = board.get_piece( [7, rank] )
    return false unless partner.is_a?(Rook)
    return false unless partner.color == self.color
    return false if partner.has_moved

    return false unless self.location == [4, rank]
    return false if self.has_moved

    return true
  end

  def castle_long_available?(board)
    self.color == 'white' ? rank = 0 : rank = 7
    return false unless board.empty?( [3, rank] )
    return false unless board.empty?( [2, rank] )
    return false unless board.empty?( [1, rank] )

    partner = board.get_piece( [0, rank] )
    return false unless partner.is_a?(Rook)
    return false unless partner.color == self.color
    return false if partner.has_moved

    return false unless self.location == [4, rank]
    return false if self.has_moved

    return true
  end
end