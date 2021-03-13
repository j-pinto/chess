require './lib/required_files.rb'

describe Move do
  it 'returns correct standard move data given correct input' do
    mock_board = Board.new()
    start = [0,1]
    finish = [0,3]
    piece = mock_board.get_piece(start)
    piece.update_reachable_locations(mock_board)

    mock_input = double('input')
    allow(mock_input).to receive(:start) { start }
    allow(mock_input).to receive(:finish) { finish }

    mock_turn = double('turn')
    allow(mock_turn).to receive(:current_player) { Player.new('white') }
    allow(mock_turn).to receive(:board) {mock_board}
    allow(mock_turn).to receive(:input) {mock_input}

    
    selector = MoveTypeSelector.new(mock_turn)
    expect(selector.start).to eql(start)
    expect(selector.finish).to eql(finish)
    selector.set_output()
    expect(selector.piece).to eql(piece)
    expect(selector.output).to eql('STANDARD')

    move = StandardMove.new(mock_turn)
    expect(move.start).to eql(start)
    expect(move.finish).to eql(finish)
    expect(move.selected_piece).to eql(piece)
  end

  it 'returns correct capture move data given correct input' do

    mock_board = Board.new()
    mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }
    start = [3,3]
    finish = [0,0]
    mock_board.grid[start] = Bishop.new('black', start)
    mock_board.grid[finish] = Queen.new('white', finish)
    piece = mock_board.get_piece(start)
    target = mock_board.get_piece(finish)
    piece.update_reachable_locations(mock_board)

    mock_input = double('input')
    allow(mock_input).to receive(:start) { start }
    allow(mock_input).to receive(:finish) { finish }

    mock_turn = double('turn')
    allow(mock_turn).to receive(:current_player) { Player.new('black') }
    allow(mock_turn).to receive(:board) {mock_board}
    allow(mock_turn).to receive(:input) {mock_input}

    
    selector = MoveTypeSelector.new(mock_turn)
    expect(selector.start).to eql(start)
    expect(selector.finish).to eql(finish)
    selector.set_output()
    expect(selector.piece).to eql(piece)
    expect(selector.output).to eql('CAPTURE')

    move = CaptureMove.new(mock_turn)
    expect(move.start).to eql(start)
    expect(move.finish).to eql(finish)
    expect(move.selected_piece).to eql(piece)
    expect(move.captured_piece).to eql(target)
  end

  it 'returns correct en pass move data given correct input' do

    mock_board = Board.new()
    mock_board.grid.each_pair { |square, piece| mock_board.grid[square] = nil }
    start = [0,3]
    finish = [1,2]
    ep_target_location = [1,3]
    mock_board.grid[start] = Pawn.new('black', start)
    mock_board.grid[ep_target_location] = Pawn.new('white', ep_target_location)
    piece = mock_board.get_piece(start)
    target = mock_board.get_piece(ep_target_location)

    target.en_pass_vulnerable = true
    piece.update_reachable_locations(mock_board)

    mock_input = double('input')
    allow(mock_input).to receive(:start) { start }
    allow(mock_input).to receive(:finish) { finish }

    mock_turn = double('turn')
    allow(mock_turn).to receive(:current_player) { Player.new('black') }
    allow(mock_turn).to receive(:board) {mock_board}
    allow(mock_turn).to receive(:input) {mock_input}

    
    selector = MoveTypeSelector.new(mock_turn)
    expect(selector.start).to eql(start)
    expect(selector.finish).to eql(finish)
    selector.set_output()
    expect(selector.piece).to eql(piece)
    expect(selector.output).to eql('EN_PASS')

    move = EnPassMove.new(mock_turn)
    expect(move.start).to eql(start)
    expect(move.finish).to eql(finish)
    expect(move.selected_piece).to eql(piece)
    expect(move.captured_piece).to eql(target)
  end

  it 'returns correct castle move data given correct input' do

    mock_board = Board.new()
    mock_board.grid[[1,7]] = nil
    mock_board.grid[[2,7]] = nil
    mock_board.grid[[3,7]] = nil

    start = [4,7]
    finish = [2,7]
    king = mock_board.get_piece(start)
    rook = mock_board.get_piece([0,7])
    king.update_reachable_locations(mock_board)

    mock_input = double('input')
    allow(mock_input).to receive(:start) { start }
    allow(mock_input).to receive(:finish) { finish }

    mock_turn = double('turn')
    player = Player.new('black')
    allow(mock_turn).to receive(:current_player) { player }
    allow(mock_turn).to receive(:board) {mock_board}
    allow(mock_turn).to receive(:input) {mock_input}

    selector = MoveTypeSelector.new(mock_turn)
    expect(selector.start).to eql(start)
    expect(selector.finish).to eql(finish)
    expect(selector.piece).to eql(king)
    expect(selector.current_player).to eql(player)
    selector.set_output()
    expect(selector.is_castle?).to eql(true)
    expect(selector.output).to eql('CASTLE')

    move = CastleMove.new(mock_turn)
    expect(move.start).to eql(start)
    expect(move.finish).to eql(finish)
    expect(move.king).to eql(king)
    expect(move.rook).to eql(rook)
  end
end