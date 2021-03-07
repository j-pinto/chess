require './lib/required_files.rb'

describe Input do
  describe "#valid?" do
    it "returns true if input string is correct format and in bounds" do
      input = Input.new
      expect(input.valid?('a1b2')).to eql(true)
      expect(input.valid?('A1B2')).to eql(true)
      expect(input.valid?('A1                    b2')).to eql(true)

      expect(input.valid?('A1b9')).to eql(false)
      expect(input.valid?('A1-b2')).to eql(false)
      expect(input.valid?('1122')).to eql(false)
      expect(input.valid?('foo')).to eql(false)
    end
  end
end

describe Rook do
  describe '#update_reachable_locations' do
    it "Returns array of squares reachable by piece from current location. Array has all empty squares in the piece's movement path. Array includes squares occupied by enemy pieces, but no squares beyond it. Does not return squares out of bounds, does not return squares occupied by, or beyond, a friendly piece." do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for test
      rook = Rook.new('white', [0,0])
      board.grid[[0,0]] = rook
      board.grid[[0,2]] = Pawn.new('black', [0,2])
      board.grid[[5,0]] = Pawn.new('white', [5,0])

      expected_reachable = [ [0,1], [0,2], [1,0], [2,0], [3,0], [4,0] ]
      expect(rook.update_reachable_locations(board)).to eql(expected_reachable)
    end
  end
end

describe Bishop do
  describe '#update_reachable_locations' do
    it "Returns array of squares reachable by piece from current location. Array has all empty squares in the piece's movement path. Array includes squares occupied by enemy pieces, but no squares beyond it. Does not return squares out of bounds, does not return squares occupied by, or beyond, a friendly piece." do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for test
      bishop = Bishop.new('black', [1,1])
      board.grid[[1,1]] = bishop
      board.grid[[2,0]] = Pawn.new('black', [2,0])
      board.grid[[3,3]] = Pawn.new('white', [3,3])

      expected_reachable = [ [2,2], [3,3], [0,2], [0,0] ]
      expect(bishop.update_reachable_locations(board)).to eql(expected_reachable)
    end
  end
end

describe Queen do
  describe '#update_reachable_locations' do
    it "Returns array of squares reachable by piece from current location. Array has all empty squares in the piece's movement path. Array includes squares occupied by enemy pieces, but no squares beyond it. Does not return squares out of bounds, does not return squares occupied by, or beyond, a friendly piece." do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for tests
      queen = Queen.new('black', [1,1])
      board.grid[[1,1]] = queen
      board.grid[[0,0]] = Pawn.new('black', [0,0])
      board.grid[[2,0]] = Pawn.new('black', [2,0])
      board.grid[[2,1]] = Pawn.new('black', [2,1])
      board.grid[[0,1]] = Pawn.new('white', [0,1])
      board.grid[[1,4]] = Pawn.new('white', [1,4])

      expected_reachable = [ [1,2], [1,3], [1,4], [1,0], [0,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [0,2] ]
      expect(queen.update_reachable_locations(board)).to eql(expected_reachable)
    end
  end
end



