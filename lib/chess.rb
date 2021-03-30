require_relative 'required_files'

intro = Intro.new()
intro.get_input()

loop do
  break if intro.input != nil
end

if intro.input == 'NEW'
  game = Game.new()
  board = Board.new()
  players = {
    'white' => Player.new('white'),
    'black' => Player.new('black')
  }

  game.board = board
  game.players = players
else
  exit
end

graphics = Graphics.new(game)
graphics.clear()
graphics.print_board()

loop do
  turn = Turn.new(game)
  input = Input.new()
  input.get()

  if input.data_request == true
    graphics.print_data()
    next
  elsif input.help_request == true
    graphics.print_help()
    next
  end

  loop do
    break if ( input.start != nil && input.finish != nil )
  end

  turn.input = input
  selector = MoveTypeSelector.new(turn)
  selector.set_output()

  move = nil
  case selector.output
  when 'STANDARD'
    move = StandardMove.new(turn)                                                        
  when 'CAPTURE'
    move = CaptureMove.new(turn)
  when 'EN_PASS'
    move = EnPassMove.new(turn)
  when 'CASTLE'
    move = CastleMove.new(turn)
  when 'INVALID'
    puts "move is invalid"
    next
  end

  loop do
    break if move != nil
  end
 
  update = Update.new(move)
  update.execute()
  if update.valid?()
    update.finalize()
    game.data_update(input, update)
  else
    update.revert()
    puts "move would result in check"
    next
  end

  graphics.clear()
  graphics.print_board()

  if update.check_data['in_check'] == true
    analysis = CheckAnalysis.new(update)
    if analysis.checkmate == true
      exit
    end
  end
end
