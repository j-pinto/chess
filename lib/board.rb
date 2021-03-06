class Board
  attr_accessor :grid

  def initialize(pieces)
    @pieces = pieces
    @grid = {}
    make()
  end

  private

  def make
    half_array = (0..7).to_a
    full_array = half_array.repeated_permutation(2).to_a

    full_array.each { |location| @grid[location] = nil }

    populate()
  end

  def populate
    @pieces.each do |piece|
      location = piece.location
      @grid[location] = piece
    end
  end
#
end
