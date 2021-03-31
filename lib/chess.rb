require_relative 'required_files'

intro = Intro.new()
intro.get_input()

loop do
  break if intro.input != nil
end

if intro.input == 'NEW'
  game = Game.new()
elsif intro.input == 'LOAD'
  game = SaveLoad.load()
else
  exit
end

graphics = Graphics.new(game)
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
  elsif input.save_request == true
    SaveLoad.save(game)
    Prompts.saved()
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
    graphics.clear()
    graphics.print_board()
  else
    update.revert()
    next
  end

  if update.check_data['in_check'] == true
    Prompts.check()
    analysis = CheckAnalysis.new(update)
    if analysis.checkmate == true
      Prompts.checkmate()
      Prompts.winner(turn.current_player.color)
      exit
    end
  end
end
