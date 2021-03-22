require './lib/required_files.rb'

describe CheckAnalysis do
  it 'appropriately sets @checkmate = true for a given board showing checkmate' do
    mock_board = Board.new()
    mock_board.grid[[5,1]] = nil
    mock_board.grid[[6,1]] = nil
    mock_board.grid[[7,3]] = Queen.new('black', [7,3])
    mock_board.refresh_piece_data()
    king = mock_board.get_piece([4,0])
    threat = mock_board.get_piece([7,3])

    puts ""
    Graphics.print_board(mock_board)

    mock_check_data = {
      'king' => king,
      'threat' => threat
    }

    update = double('update')
    allow(update).to receive(:board) {mock_board}
    allow(update).to receive(:check_data) {mock_check_data}

    analysis = CheckAnalysis.new(update)
    expect(analysis.checkmate).to eql(true)
  end

  it 'appropriately sets @checkmate = false when check is blockable' do
    mock_board = Board.new()
    mock_board.grid[[4,1]] = nil
    mock_board.grid[[5,1]] = nil
    mock_board.grid[[4,6]] = mock_board.grid[[3,7]]
    mock_board.grid[[3,7]] = nil
    mock_board.refresh_piece_data()
    king = mock_board.get_piece([4,0])
    threat = mock_board.get_piece([4,6])

    puts ""
    Graphics.print_board(mock_board)

    mock_check_data = {
      'king' => king,
      'threat' => threat
    }

    update = double('update')
    allow(update).to receive(:board) {mock_board}
    allow(update).to receive(:check_data) {mock_check_data}

    analysis = CheckAnalysis.new(update)
    expect(analysis.checkmate).to eql(false)
  end

  it 'appropriately sets @checkmate = false when king can move out of check' do
    mock_board = Board.new()
    mock_board.grid[[4,1]] = nil
    mock_board.grid[[5,1]] = nil
    mock_board.grid[[3,0]] = Pawn.new('white', [3,0])
    mock_board.grid[[5,0]] = Pawn.new('white', [5,0])
    mock_board.grid[[6,0]] = Pawn.new('white', [6,0])
    mock_board.grid[[4,6]] = mock_board.grid[[3,7]]
    mock_board.grid[[3,7]] = nil
    mock_board.refresh_piece_data()
    king = mock_board.get_piece([4,0])
    threat = mock_board.get_piece([4,6])

    puts ""
    Graphics.print_board(mock_board)

    mock_check_data = {
      'king' => king,
      'threat' => threat
    }

    update = double('update')
    allow(update).to receive(:board) {mock_board}
    allow(update).to receive(:check_data) {mock_check_data}

    analysis = CheckAnalysis.new(update)
    expect(analysis.checkmate).to eql(false)
  end

  it 'appropriately sets @checkmate = false when threat can be captured' do
    mock_board = Board.new()
    mock_board.grid[[5,1]] = nil
    mock_board.grid[[6,2]] = mock_board.grid[[3,7]]
    mock_board.grid[[3,7]] = nil
    mock_board.refresh_piece_data()
    king = mock_board.get_piece([4,0])
    threat = mock_board.get_piece([6,2])

    puts ""
    Graphics.print_board(mock_board)

    mock_check_data = {
      'king' => king,
      'threat' => threat
    }

    update = double('update')
    allow(update).to receive(:board) {mock_board}
    allow(update).to receive(:check_data) {mock_check_data}

    analysis = CheckAnalysis.new(update)
    expect(analysis.checkmate).to eql(false)
  end
end
