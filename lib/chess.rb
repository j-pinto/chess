require_relative 'required_files'

game = Game.new()
board = Board.new()
players = {
  'white' => Player.new('white'),
  'black' => Player.new('black')
}

game.board = board
game.players = players

Graphics.print_board(board)
loop do
  puts "count: #{game.turn_count}"
  turn = Turn.new(game)
  input = Input.new()
  input.get()

  loop do
    break if ( input.start != nil && input.finish != nil )
  end

  turn.input = input
  selector = MoveTypeSelector.new(turn)
  selector.set_output()
  puts "#{selector.output}"

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
    game.turn_count += 1
  else
    update.revert()
    puts "move would result in check"
    next
  end

  puts ""
  Graphics.print_board(board)

  if update.check_data['in_check'] == true
    analysis = CheckAnalysis.new(update)
    if analysis.checkmate == true
      exit
    end
  end
end
