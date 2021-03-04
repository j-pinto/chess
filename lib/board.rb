class Board
  attr_accessor :grid

  def initialize
    @grid = {}
    make()
    print()
  end

  def make()
    half_array = (0..7).to_a
    full_array = half_array.repeated_permutation(2).to_a

    full_array.each { |item| @grid[item] = nil }
  end

#
end
