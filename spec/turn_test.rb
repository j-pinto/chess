require './lib/required_files.rb'

describe Turn do
  it 'appropriately switches current player as turn count increments' do
    game = Game.new()
    board = Board.new()
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    game.board = board
    game.players = players

    puts ""
    until game.turn_count == 10
      puts "count: #{game.turn_count}"
      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end
      game.turn_count += 1
    end
  end

  it 'switches current player according to turn count, leads to selector.output == STANDARD for series of valid inputs corresponding to standard moves' do
    game = Game.new()
    board = Board.new()
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    game.board = board
    game.players = players

    puts ""
    mock_starts = [
      [0,1],[0,6],[1,0],[1,7]
    ]
    mock_finishes = [
      [0,2],[0,5],[2,2],[2,5]
    ]

    loop do
      puts "count: #{game.turn_count}"
      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end

      input = double('input')
      start = mock_starts.slice!(0)
      finish = mock_finishes.slice!(0)
      allow(input).to receive(:start) {start}
      allow(input).to receive(:finish) {finish}

      allow(turn).to receive(:input) {input}
      puts "#{turn.input.start}"
      puts "#{turn.input.finish}"

      selector = MoveTypeSelector.new(turn)
      selector.set_output()
      expect(selector.output).to eql('STANDARD')

      game.turn_count += 1
      break if game.turn_count == 4
    end
  end

  it 'switches current player according to turn count, leads to correct selector output, including INVALID if input start occupied by piece of wrong color' do
    game = Game.new()
    board = Board.new()
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    game.board = board
    game.players = players

    puts ""
    mock_starts = [
      [0,1],[0,6],[1,0],[0,0]
    ]
    mock_finishes = [
      [0,2],[0,5],[2,2],[0,1]
    ]

    loop do
      puts "count: #{game.turn_count}"
      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end

      input = double('input')
      start = mock_starts.slice!(0)
      finish = mock_finishes.slice!(0)
      allow(input).to receive(:start) {start}
      allow(input).to receive(:finish) {finish}

      allow(turn).to receive(:input) {input}
      puts "#{turn.input.start}"
      puts "#{turn.input.finish}"

      selector = MoveTypeSelector.new(turn)
      selector.set_output()

      if game.turn_count == 3
        expect(selector.output).to eql('INVALID')
      else
        expect(selector.output).to eql('STANDARD')
      end

      game.turn_count += 1
      break if game.turn_count == 4
    end
  end

  it 'switches current player according to turn count, leads to correct selector output, including INVALID if input selects unreachable finish' do
    game = Game.new()
    board = Board.new()
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    game.board = board
    game.players = players

    puts ""
    mock_starts = [
      [0,1],[0,6],[1,0],[1,7]
    ]
    mock_finishes = [
      [0,2],[0,5],[2,2],[2,6]
    ]

    loop do
      puts "count: #{game.turn_count}"
      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end

      input = double('input')
      start = mock_starts.slice!(0)
      finish = mock_finishes.slice!(0)
      allow(input).to receive(:start) {start}
      allow(input).to receive(:finish) {finish}

      allow(turn).to receive(:input) {input}
      puts "#{turn.input.start}"
      puts "#{turn.input.finish}"

      selector = MoveTypeSelector.new(turn)
      selector.set_output()

      if game.turn_count == 3
        expect(selector.output).to eql('INVALID')
      else
        expect(selector.output).to eql('STANDARD')
      end

      game.turn_count += 1
      break if game.turn_count == 4
    end
  end

  it 'switches current player according to turn count, but only increments turn count if inputs are a valid move' do
    game = Game.new()
    board = Board.new()
    players = {
      'white' => Player.new('white'),
      'black' => Player.new('black')
    }

    game.board = board
    game.players = players

    puts ""
    mock_starts = [
      [0,1],[3,0],[0,1],[0,6]
    ]
    mock_finishes = [
      [0,4],[4,1],[0,3],[0,4]
    ]

    loop do
      expect(game.turn_count).to eql(0)

      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end

      input = double('input')
      start = mock_starts.slice!(0)
      finish = mock_finishes.slice!(0)
      allow(input).to receive(:start) {start}
      allow(input).to receive(:finish) {finish}

      allow(turn).to receive(:input) {input}
      puts "#{turn.input.start}"
      puts "#{turn.input.finish}"

      selector = MoveTypeSelector.new(turn)
      selector.set_output()

      if selector.output == 'STANDARD'
        game.turn_count += 1        
      end

      break if game.turn_count == 1
    end
  end
  
end