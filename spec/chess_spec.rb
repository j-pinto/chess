require './lib/required_files.rb'

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
 
describe King do
  describe '#update_reachable_locations' do
    it "Returns array of squares reachable by piece from current location. For King, a max of one step in any direction is allowed. May reach enemy occupied squares. Cannot reach friendly occupied or out of bounds sqaures" do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for tests
      king = King.new('white', [1,1])
      board.grid[[1,1]] = king
      board.grid[[1,5]] = Pawn.new('black', [1,5])
      board.grid[[1,0]] = Pawn.new('black', [2,0])
      board.grid[[0,1]] = Pawn.new('white', [0,1])

      expected_array = [ [0,0], [1,0], [2,0], [2,1], [0,2], [1,2], [2,2] ]
      actual_array = king.update_reachable_locations(board)
      expect(expected_array & actual_array).to eql(expected_array)
    end
  end

  describe '#castle_short_available?' do
    it "Returns true if king and kingside rook have not moved and squares between are empty" do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for tests
      white_king = King.new('white', [4,0])
      board.grid[[4,0]] = white_king
      white_rook = Rook.new('white', [7,0])
      board.grid[[7,0]] = white_rook

      black_king = King.new('black', [4,7])
      board.grid[[4,7]] = black_king
      black_rook = Rook.new('black', [7,7])
      board.grid[[7,7]] = black_rook

      expect(white_king.castle_short_available?(board)).to eql(true)
      expect(black_king.castle_short_available?(board)).to eql(true)
      white_king.update_reachable_locations(board)
      black_king.update_reachable_locations(board)
      expect(white_king.can_castle_short).to eql(true)
      expect(black_king.can_castle_short).to eql(true)

      blocking_piece = Pawn.new('white', [5,0])
      board.grid[[5,0]] = blocking_piece
      expect(white_king.castle_short_available?(board)).to eql(false)

      board.grid[[5,0]] = nil
      board.grid[[7,0]] = Knight.new('white', [7,0])
      expect(white_king.castle_short_available?(board)).to eql(false)

      black_king.has_moved = true
      expect(black_king.castle_short_available?(board)).to eql(false)
    end
  end

  describe '#castle_long_available?' do
    it "Returns true if king and queenside rook have not moved and squares between are empty" do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for tests
      white_king = King.new('white', [4,0])
      board.grid[[4,0]] = white_king
      white_rook = Rook.new('white', [0,0])
      board.grid[[0,0]] = white_rook

      black_king = King.new('black', [4,7])
      board.grid[[4,7]] = black_king
      black_rook = Rook.new('black', [0,7])
      board.grid[[0,7]] = black_rook

      expect(white_king.castle_long_available?(board)).to eql(true)
      expect(black_king.castle_long_available?(board)).to eql(true)
      white_king.update_reachable_locations(board)
      black_king.update_reachable_locations(board)
      expect(white_king.can_castle_long).to eql(true)
      expect(black_king.can_castle_long).to eql(true)

      blocking_piece = Pawn.new('white', [1,0])
      board.grid[[1,0]] = blocking_piece
      expect(white_king.castle_long_available?(board)).to eql(false)

      board.grid[[1,0]] = nil
      not_a_rook = Knight.new('white', [7,0])
      board.grid[[0,0]] = not_a_rook
      expect(white_king.castle_long_available?(board)).to eql(false)

      black_king.has_moved = true
      expect(black_king.castle_long_available?(board)).to eql(false)
    end
  end
end
 
describe Knight do
  describe '#update_reachable_locations' do
    it "Returns array of squares reachable by piece from current location. For Knight, a max of one jump is allowed. May reach enemy occupied squares. Cannot reach friendly occupied or out of bounds sqaures" do
      #create new board, then wipe all pieces
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      #create new pieces at specific locations for tests
      knight = Knight.new('white', [1,1])
      board.grid[[1,1]] = knight
      board.grid[[2,3]] = Pawn.new('black', [2,3])
      board.grid[[3,2]] = Pawn.new('white', [3,2])

      expected_array = [ [3,0], [0,3], [2,3] ]
      actual_array = knight.update_reachable_locations(board)
      expect(expected_array & actual_array).to eql(expected_array)
    end
  end
end
 
describe Pawn do
  describe '#update_reachable_locations' do
    it "returns two steps ahead of pawn if pawn has not been moved" do
      board = Board.new
      pawn = board.grid[[0,1]]
      pawn.has_moved = false
      expect(pawn.update_reachable_locations(board)).to eql([ [0,2], [0,3] ])
    end
  end

  describe '#update_reachable_locations' do
    it "returns one step ahead of pawn if pawn has been moved" do
      board = Board.new
      pawn = board.grid[[0,1]]
      pawn.has_moved = true
      expect(pawn.update_reachable_locations(board)).to eql([ [0,2] ])
    end
  end

  describe '#update_reachable_captures' do
    it "returns array of squares reachable by the pawn that result in capture" do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      white_pawn = Pawn.new('white', [0,5])
      board.grid[[0,5]] = white_pawn
      black_pawn = Pawn.new('black', [1,6])
      board.grid[[1,6]] = black_pawn

      expect(white_pawn.update_reachable_captures(board)).to eql( [ [1,6] ] )
      expect(black_pawn.update_reachable_captures(board)).to eql( [ [0,5] ] )
    end
  end

  describe '#update_reachable_captures' do
    it "returns array of squares reachable by the pawn that result in en passant" do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      white_pawn = Pawn.new('white', [1,4])
      board.grid[[1,4]] = white_pawn

      target_pawn = Pawn.new('black', [0,4])
      target_pawn.en_pass_vulnerable = true
      board.grid[[0,4]] = target_pawn

      fake_target_pawn = Pawn.new('black', [2,4])
      fake_target_pawn.en_pass_vulnerable = false
      board.grid[[2,4]] = fake_target_pawn

      expect(white_pawn.update_reachable_captures(board)).to eql( [ [0,5] ] )
    end
  end
end