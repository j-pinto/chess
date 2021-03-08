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

describe MoveTypeSelector do
  describe '#start_valid?' do
    it 'returns true if move given is a castle and castle is valid' do
      mock_board = Board.new

      mock_input = double('input')
      allow(mock_input).to receive(:start) {[0,0]}
      allow(mock_input).to receive(:finish) {[0,1]}

      mock_turn = double('turn')
      mock_player = Player.new('white')
      allow(mock_turn).to receive(:current_player) {mock_player}

      mock_turn2 = double('turn')
      mock_player2 = Player.new('black')
      allow(mock_turn2).to receive(:current_player) {mock_player2}

      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)

      move_type_selector = MoveTypeSelector.new(mock_turn2, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(false)
    end
  end

  describe '#is_castle?' do
    it 'returns true if move given is a castle and castle is valid' do
      mock_board = Board.new
      mock_board.grid[[5,0]] = nil
      mock_board.grid[[6,0]] = nil
  
      mock_input = double('input')
      allow(mock_input).to receive(:start) {[4,0]}
      allow(mock_input).to receive(:finish) {[6,0]}
  
      mock_turn = double('turn')
      mock_player = Player.new('white')
      allow(mock_turn).to receive(:current_player) {mock_player}
  
      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_castle?).to eql(true)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('CASTLE')
  
      mock_board2 = Board.new
      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board2)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_castle?).to eql(false)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('INVALID')
    end
  end

  describe '#is_en_pass?' do
    it 'returns true if move given is an en passant and is valid' do
      mock_board = Board.new
      mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }

      white_pawn = Pawn.new('white', [1,4])
      mock_board.grid[[1,4]] = white_pawn

      target_pawn = Pawn.new('black', [0,4])
      target_pawn.en_pass_vulnerable = true
      mock_board.grid[[0,4]] = target_pawn

      mock_input = double('input')
      allow(mock_input).to receive(:start) {[1,4]}
      allow(mock_input).to receive(:finish) {[0,5]}
  
      mock_turn = double('turn')
      mock_player = Player.new('white')
      allow(mock_turn).to receive(:current_player) {mock_player}

      white_pawn.update_reachable_captures(mock_board)
      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_en_pass?).to eql(true)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('EN_PASS')
    end
  end

  describe '#is_capture?' do
    it 'returns true if move is a capture and is valid' do
      mock_board = Board.new
      mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }

      knight = Knight.new('white', [1,4])
      mock_board.grid[[1,4]] = knight

      target = Pawn.new('black', [3,5])
      mock_board.grid[[3,5]] = target

      mock_input = double('input')
      allow(mock_input).to receive(:start) {[1,4]}
      allow(mock_input).to receive(:finish) {[3,5]}
  
      mock_turn = double('turn')
      mock_player = Player.new('white')
      allow(mock_turn).to receive(:current_player) {mock_player}

      knight.update_reachable_locations(mock_board)
      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_capture?).to eql(true)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('CAPTURE')
    end
  end

  describe '#is_standard?' do
    it 'returns true if move is standard and is valid' do
      mock_board = Board.new
      mock_board.grid[[0,6]] = nil

      mock_input = double('input')
      allow(mock_input).to receive(:start) {[0,7]}
      allow(mock_input).to receive(:finish) {[0,3]}
  
      mock_turn = double('turn')
      mock_player = Player.new('black')
      allow(mock_turn).to receive(:current_player) {mock_player}

      mock_board.grid[[0,7]].update_reachable_locations(mock_board)
      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_standard?).to eql(true)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('STANDARD')

      mock_input2 = double('input')
      allow(mock_input2).to receive(:start) {[0,7]}
      allow(mock_input2).to receive(:finish) {[1,3]}

      move_type_selector = MoveTypeSelector.new(mock_turn, mock_input2, mock_board)
      expect(move_type_selector.start_valid?).to eql(true)
      expect(move_type_selector.is_standard?).to eql(false)
      move_type_selector.set_output()
      expect(move_type_selector.output).to eql('INVALID')
    end
  end

end

describe StandardMove do
  it "assigns correct start, finish and selected piece given a valid standard move" do
  mock_board = Board.new

  mock_selector = double('move_type_selector')
  allow(mock_selector).to receive(:start) { [0,1] }
  allow(mock_selector).to receive(:finish) { [0,2] }
  allow(mock_selector).to receive(:output) {'STANDARD'}
  piece = mock_board.get_piece([0,1])
  allow(mock_selector).to receive(:piece) {piece}

  move = StandardMove.new(mock_selector, mock_board)
  expect(move.selected_piece).to eql(piece)
  expect(move.start).to eql(mock_selector.start)
  expect(move.finish).to eql(mock_selector.finish)
  end
end

describe CaptureMove do
  it "assigns correct start, finish, selected piece and captured piece given a valid capture" do
  mock_board = Board.new
  mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }

  piece = Queen.new('black', [0,0])
  target = Pawn.new('white', [5,5])
  mock_board.grid[[0,0]] = piece
  mock_board.grid[[5,5]] = target

  mock_selector = double('move_type_selector')
  allow(mock_selector).to receive(:start) { [0,0] }
  allow(mock_selector).to receive(:finish) { [5,5] }
  allow(mock_selector).to receive(:output) {'CAPTURE'}
  allow(mock_selector).to receive(:piece) {piece}
  
  move = CaptureMove.new(mock_selector, mock_board)
  expect(move.selected_piece).to eql(piece)
  expect(move.captured_piece).to eql(target)
  expect(move.start).to eql(mock_selector.start)
  expect(move.finish).to eql(mock_selector.finish)
  end
end
      