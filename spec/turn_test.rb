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
      turn = Turn.new(game)
      if game.turn_count.even?
        expect(turn.prompt()).to eql("White To Move")
      else
        expect(turn.prompt()).to eql("Black To Move")
      end
      game.turn_count += 1
    end
  end
end