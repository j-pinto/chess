require './lib/required_files.rb'

describe MoveTypeSelector do
  describe '#start_valid?' do
    it 'returns true when given valid starting square' do
      board = Board.new

      input = double('input')
      allow(input).to receive(:start) {[0,0]}
      allow(input).to receive(:finish) {[0,1]}

      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
    end

    it 'returns false when given invalid starting square' do
      board = Board.new

      input = double('input')
      allow(input).to receive(:start) {[0,0]}
      allow(input).to receive(:finish) {[0,1]}

      turn = double('turn')
      player = Player.new('black')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(false)
    end
  end

  describe '#is_castle?' do
    it 'returns true if move given is a castle and castle is valid' do
      board = Board.new
      board.grid[[5,0]] = nil
      board.grid[[6,0]] = nil
      king = board.get_piece([4,0])
      king.update_reachable_locations(board)
  
      input = double('input')
      allow(input).to receive(:start) {[4,0]}
      allow(input).to receive(:finish) {[6,0]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}
  
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_castle?).to eql(true)
      selector.set_output()
      expect(selector.output).to eql('CASTLE')
    end

    it 'returns false if move given is a castle and castle is valid' do
      board = Board.new
  
      input = double('input')
      allow(input).to receive(:start) {[4,0]}
      allow(input).to receive(:finish) {[6,0]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}
  
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_castle?).to eql(false)
      selector.set_output()
      expect(selector.output).to eql('INVALID')
    end
  end

  describe '#is_en_pass?' do
    it 'returns true if move given is an en passant and is valid' do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      white_pawn = Pawn.new('white', [1,4])
      board.grid[[1,4]] = white_pawn

      target_pawn = Pawn.new('black', [0,4])
      target_pawn.en_pass_vulnerable = true
      board.grid[[0,4]] = target_pawn

      input = double('input')
      allow(input).to receive(:start) {[1,4]}
      allow(input).to receive(:finish) {[0,5]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      white_pawn.update_reachable_captures(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_en_pass?).to eql(true)
      selector.set_output()
      expect(selector.output).to eql('EN_PASS')
    end

    it 'returns false if move given is an en passant but is not valid' do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      white_pawn = Pawn.new('white', [1,4])
      board.grid[[1,4]] = white_pawn

      target_pawn = Pawn.new('black', [0,4])
      target_pawn.en_pass_vulnerable = false
      board.grid[[0,4]] = target_pawn

      input = double('input')
      allow(input).to receive(:start) {[1,4]}
      allow(input).to receive(:finish) {[0,5]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      white_pawn.update_reachable_captures(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_en_pass?).to eql(false)
      selector.set_output()
      expect(selector.output).to eql('INVALID')
    end
  end

  describe '#is_capture?' do
    it 'returns true if move is a capture and is valid' do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      knight = Knight.new('white', [1,4])
      board.grid[[1,4]] = knight

      target = Pawn.new('black', [3,5])
      board.grid[[3,5]] = target

      input = double('input')
      allow(input).to receive(:start) {[1,4]}
      allow(input).to receive(:finish) {[3,5]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      knight.update_reachable_locations(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_capture?).to eql(true)
      selector.set_output()
      expect(selector.output).to eql('CAPTURE')
    end

    it 'returns false if move is not a capture' do
      board = Board.new
      board.grid.each_pair { |square, piece| board.grid[square] = nil }

      knight = Knight.new('white', [1,4])
      board.grid[[1,4]] = knight

      input = double('input')
      allow(input).to receive(:start) {[1,4]}
      allow(input).to receive(:finish) {[3,5]}
  
      turn = double('turn')
      player = Player.new('white')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      knight.update_reachable_locations(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_capture?).to eql(false)
      selector.set_output()
      expect(selector.output).to eql('STANDARD')
    end
  end

  describe '#is_standard?' do
    it 'returns true if move is standard and is valid' do
      board = Board.new
      board.grid[[0,6]] = nil

      input = double('input')
      allow(input).to receive(:start) {[0,7]}
      allow(input).to receive(:finish) {[0,3]}
  
      turn = double('turn')
      player = Player.new('black')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      board.grid[[0,7]].update_reachable_locations(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_standard?).to eql(true)
      selector.set_output()
      expect(selector.output).to eql('STANDARD')
    end

    it 'returns false if move is not valid' do
      board = Board.new
      board.grid[[0,6]] = nil

      input = double('input')
      allow(input).to receive(:start) {[0,7]}
      allow(input).to receive(:finish) {[1,3]}

      turn = double('turn')
      player = Player.new('black')
      allow(turn).to receive(:current_player) {player}
      allow(turn).to receive(:board) {board}
      allow(turn).to receive(:input) {input}

      board.grid[[0,7]].update_reachable_locations(board)
      selector = MoveTypeSelector.new(turn)
      expect(selector.start_valid?).to eql(true)
      expect(selector.is_standard?).to eql(false)
      selector.set_output()
      expect(selector.output).to eql('INVALID')
    end
  end
end