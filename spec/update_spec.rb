require './lib/required_files.rb'

describe Update do
  describe '#execute' do
    it 'execute() updates board according to standard move data, revert() undoes change' do
      mock_board = Board.new()
      player = Player.new('white')
      start = [0,1]
      finish = [0,2]
      piece = mock_board.get_piece(start)
      piece.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = StandardMove.new(mock_turn)
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(piece)
      expect(temp_update.board.get_piece(start)).to eql(nil)

      temp_update.revert()
      expect(temp_update.board.get_piece(finish)).to eql(nil)
      expect(temp_update.board.get_piece(start)).to eql(piece)
    end

    it 'execute() updates board according to capture move data, revert() undoes change' do
      mock_board = Board.new()
      piece = Queen.new('white', [3,3])
      mock_board.grid[[3,3]] = piece
      target = Knight.new('black', [5,5])
      mock_board.grid[[5,5]] = target
      player = Player.new('white')
      start = [3,3]
      finish = [5,5]
      piece.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = CaptureMove.new(mock_turn)
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(piece)
      expect(temp_update.board.get_piece(start)).to eql(nil)
      expect(temp_update.move.captured_piece).to eql(target)

      temp_update.revert()
      expect(temp_update.board.get_piece(finish)).to eql(target)
      expect(temp_update.board.get_piece(start)).to eql(piece)
    end

    it 'execute() updates board according to en pass move data, revert() undoes change' do
      mock_board = Board.new()
      start = [0,4]
      finish = [1,5]
      piece = Pawn.new('white', start)
      mock_board.grid[start] = piece
      target = Pawn.new('black', [1,4])
      mock_board.grid[[1,4]] = target
      player = Player.new('white')
      target.en_pass_vulnerable = true
      piece.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = EnPassMove.new(mock_turn)
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(piece)
      expect(temp_update.board.get_piece(start)).to eql(nil)
      expect(temp_update.move.captured_piece).to eql(target)
      expect(temp_update.board.get_piece(move.target_location)).to eql(nil)

      temp_update.revert()
      expect(temp_update.board.get_piece(finish)).to eql(nil)
      expect(temp_update.board.get_piece(start)).to eql(piece)
      expect(temp_update.board.get_piece(move.target_location)).to eql(target)
    end

    it 'execute() updates board according to castle move data, revert() undoes change' do
      player = Player.new('white')
      mock_board = Board.new()
      mock_board.grid[[1,0]] = nil    
      mock_board.grid[[2,0]] = nil
      mock_board.grid[[3,0]] = nil    
      start = [4,0]
      finish = [2,0]
      king = mock_board.get_piece(start)
      king.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = CastleMove.new(mock_turn)
      rook = move.rook
      rook_start = move.rook_start
      rook_finish = move.rook_finish
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(king)
      expect(temp_update.board.get_piece(start)).to eql(nil)
      expect(temp_update.board.get_piece(rook_start)).to eql(nil)
      expect(temp_update.board.get_piece(rook_finish)).to eql(rook)

      temp_update.revert()
      expect(temp_update.board.get_piece(finish)).to eql(nil)
      expect(temp_update.board.get_piece(start)).to eql(king)
      expect(temp_update.board.get_piece(rook_start)).to eql(rook)
      expect(temp_update.board.get_piece(rook_finish)).to eql(nil)
    end
  end

  describe '#valid' do
    it 'valid?() returns true if move would not result in players own king being in check'  do
      mock_board = Board.new()
      player = Player.new('white')
      start = [0,1]
      finish = [0,2]
      piece = mock_board.get_piece(start)
      piece.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = StandardMove.new(mock_turn)
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(piece)
      expect(temp_update.board.get_piece(start)).to eql(nil)

      expect(temp_update.valid?()).to eql(true)
    end

    it 'valid?() returns false if move would result in players own king being in check' do
      player = Player.new('white')
      mock_board = Board.new()
      mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }
      start = [0,1]
      finish = [1,1]
      piece = Rook.new('white', [0,1])
      king = King.new('white', [0,0])
      threat = Queen.new('black', [0,7])
      mock_board.grid[start] = piece
      mock_board.grid[[0,0]] = king
      mock_board.grid[[0,7]] = threat

      piece.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      move = StandardMove.new(mock_turn)
      temp_update = Update.new(move)

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(piece)
      expect(temp_update.board.get_piece(start)).to eql(nil)

      expect(temp_update.valid?()).to eql(false)
    end

    it 'valid?() returns false if king passes through threatened square during castle' do
      player = Player.new('white')
      mock_board = Board.new()
      mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }
      start = [4,0]
      finish = [2,0]
      rook = Rook.new('white', [0,0])
      king = King.new('white', start)
      threat = Queen.new('black', [3,7])
      mock_board.grid[start] = king
      mock_board.grid[[0,0]] = rook
      mock_board.grid[[3,7]] = threat

      king.update_reachable_locations(mock_board)

      mock_input = double('input')
      allow(mock_input).to receive(:start) { start }
      allow(mock_input).to receive(:finish) { finish }

      mock_turn = double('turn')
      allow(mock_turn).to receive(:current_player) { player }
      allow(mock_turn).to receive(:board) {mock_board}
      allow(mock_turn).to receive(:input) {mock_input}

      selector = MoveTypeSelector.new(mock_turn)
      selector.set_output()
      move = nil
      temp_update = nil
      if selector.output == 'CASTLE'
        move = CastleMove.new(mock_turn)
        temp_update = Update.new(move)
      end

      temp_update.execute()
      expect(temp_update.board.get_piece(finish)).to eql(king)
      expect(temp_update.board.get_piece(start)).to eql(nil)

      expect(temp_update.valid?()).to eql(false)
    end
  end

  describe '#finalize' do
    it 'results in correctly updated board given a valid standard move' do
      game = Game.new()
      players = {
        'white' => Player.new('white'),
        'black' => Player.new('black')
      }
      board = Board.new()
      game.board = board
      game.players = players

      mock_input = double('input')
      start = [1,0]
      finish = [2,2]
      allow(mock_input).to receive(:start) {start}
      allow(mock_input).to receive(:finish) {finish}

      turn = Turn.new(game)
      turn.input = mock_input
      
      selector = MoveTypeSelector.new(turn)
      selector.set_output()
      selector_output = selector.output
      case selector_output
      when 'STANDARD'
        move = StandardMove.new(turn)
      when 'CAPTURE'
        move = CaptureMove.new(turn)
      when 'EN_PASS'
        move = EnPassMove.new(turn)
      when 'CASTLE'
        move = CastleMove.new(turn)
      else
        puts "selector error"
      end

      update = Update.new(move)
      update.execute()
      update.valid?() ? update.finalize() : update.revert()

      board.grid.each_pair { |square, piece|
        next if piece == nil
        expect(piece.location).to eql(square)

        if piece.location == finish
          expect(piece.has_moved).to eql(true)
        else
          expect(piece.has_moved).to eql(false)
        end
      }
    end

    it 'results in correctly updated board given a valid standard move, including pawn en pass vulnerability' do
      game = Game.new()
      players = {
        'white' => Player.new('white'),
        'black' => Player.new('black')
      }
      board = Board.new()
      game.board = board
      game.players = players

      mock_input = double('input')
      start = [0,1]
      finish = [0,3]
      allow(mock_input).to receive(:start) {start}
      allow(mock_input).to receive(:finish) {finish}

      turn = Turn.new(game)
      turn.input = mock_input
      
      selector = MoveTypeSelector.new(turn)
      selector.set_output()
      selector_output = selector.output
      case selector_output
      when 'STANDARD'
        move = StandardMove.new(turn)
      when 'CAPTURE'
        move = CaptureMove.new(turn)
      when 'EN_PASS'
        move = EnPassMove.new(turn)
      when 'CASTLE'
        move = CastleMove.new(turn)
      else
        puts "selector error"
      end

      update = Update.new(move)
      update.execute()
      update.valid?() ? update.finalize() : update.revert()

      board.grid.each_pair { |square, piece|
        next if piece == nil
        expect(piece.location).to eql(square)

        if piece.location == finish
          expect(piece.has_moved).to eql(true)
          expect(piece.en_pass_vulnerable).to eql(true)
        else
          expect(piece.has_moved).to eql(false)
        end
      }
    end

    it 'results in correctly updated board and correct king check status' do
      game = Game.new()
      game.turn_count = 1

      players = {
        'white' => Player.new('white'),
        'black' => Player.new('black')
      }

      board = Board.new()
      board.grid[[4,6]] = nil
      board.grid[[4,1]] = nil
      board.refresh_piece_data()

      game.board = board
      game.players = players

      mock_input = double('input')
      start = [3,7]
      finish = [4,6]
      allow(mock_input).to receive(:start) {start}
      allow(mock_input).to receive(:finish) {finish}

      turn = Turn.new(game)
      turn.input = mock_input
      
      selector = MoveTypeSelector.new(turn)
      selector.set_output()
      selector_output = selector.output
      case selector_output
      when 'STANDARD'
        move = StandardMove.new(turn)
      when 'CAPTURE'
        move = CaptureMove.new(turn)
      when 'EN_PASS'
        move = EnPassMove.new(turn)
      when 'CASTLE'
        move = CastleMove.new(turn)
      else
        puts "selector error"
      end

      update = Update.new(move)
      update.execute()
      update.valid?() ? update.finalize() : update.revert()

      board.grid.each_pair { |square, piece|
        next if piece == nil
        expect(piece.location).to eql(square)

        if piece.location == finish
          expect(piece.has_moved).to eql(true)
        else
          expect(piece.has_moved).to eql(false)
        end

        if piece.is_a?(King) && piece.color != move.current_player.color
          expect(piece.in_check).to eql(true)
          expect(update.check_data['in_check']).to eql(true)
          expect(update.check_data['king']).to eql(board.get_piece([4,0]))
          expect(update.check_data['threat']).to eql(board.get_piece(finish))
        end
      }
    end
  end
end