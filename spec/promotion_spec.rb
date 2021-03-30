require './lib/required_files.rb'

describe Update do
####################
# disable all terminal outputs
before(:all) do
  @original_stdout = $stdout
  @original_stderr = $stderr
  $stdout = File.open(File::NULL, 'w')
  $stderr = File.open(File::NULL, 'w')
end
####################

####################
# re-enable all terminal outputs
after(:all) do
  $stdout = @original_stdout
  $stderr = @original_stderr
  @original_stdout = nil
  @original_stderr = nil
end
####################

  it 'promotes pawn that reaches end of board to queen' do
    board = Board.new()
    board.grid[[0,7]] = nil

    pawn = Pawn.new('white', [0,6])
    board.grid[[0,6]] = pawn

    board.refresh_piece_data()

    player = Player.new('white')
    start = pawn.location
    finish = [0,7]

    move = double('move')
    allow(move).to receive(:board) {board}
    allow(move).to receive(:current_player) {player}
    allow(move).to receive(:start) {start}
    allow(move).to receive(:finish) {finish}
    allow(move).to receive(:selected_piece) {pawn}

    update = Update.new(move)

    promotion_input = 'Q'
    allow(update).to receive(:get_promotion).and_return(promotion_input)

    update.execute()
    if update.valid?()
      update.finalize()
    end

    expect(update.promoted_pawn).to eql(pawn)
    expect(board.grid[start]).to eql(nil)
    expect(board.grid[finish].class).to eql(Queen)
  end

  it 'promotes pawn that reaches end of board to bishop' do
    board = Board.new()
    board.grid[[0,0]] = nil

    pawn = Pawn.new('black', [0,1])
    board.grid[[0,1]] = pawn

    board.refresh_piece_data()

    player = Player.new('black')
    start = pawn.location
    finish = [0,0]

    move = double('move')
    allow(move).to receive(:board) {board}
    allow(move).to receive(:current_player) {player}
    allow(move).to receive(:start) {start}
    allow(move).to receive(:finish) {finish}
    allow(move).to receive(:selected_piece) {pawn}

    update = Update.new(move)

    promotion_input = 'B'
    allow(update).to receive(:get_promotion).and_return(promotion_input)

    update.execute()
    if update.valid?()
      update.finalize()
    end

    expect(update.promoted_pawn).to eql(pawn)
    expect(board.grid[start]).to eql(nil)
    expect(board.grid[finish].class).to eql(Bishop)
  end
end