class Board
  attr_accessor :grid

  def initialize(pieces)
    @grid = {}
    make()
    populate(pieces)
  end

  private

  def make()
    half_array = (0..7).to_a
    full_array = half_array.repeated_permutation(2).to_a

    full_array.each { |item| @grid[item] = nil }
  end

  def populate(pieces)
    pieces.each do |piece|
      location = piece.default_position
      @grid[location] = piece
    end
  end
#
end
