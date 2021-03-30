module AutoPlay
  def AutoPlay.get_matches(file)
    strings = AutoPlay.get_game_strings(file)
    matches = AutoPlay.process_game_strings(strings)
    return matches
  end

  def AutoPlay.success?(match)
    game = AutoPlay.new_game()
    match.size.times {
      turn_complete = AutoPlay.auto_turn(game, match)
      if turn_complete == false
        return false
      end
    }
    return true
  end

  def AutoPlay.new_game
    game = Game.new()
    board = Board.new()
    players = {
    'white' => Player.new('white'),
    'black' => Player.new('black')
    }
  
    game.board = board
    game.players = players

    return game
  end

  def AutoPlay.auto_turn(game, match)
    turn = AutoPlayTurn.new(game)
    input = Input.new()
    input.input_string = match[game.turn_count].upcase
    converted_input = input.convert()
    input.start = converted_input[0] 
    input.finish = converted_input[1]

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
      return false
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
      return false
    end

    if update.check_data['in_check'] == true
      analysis = CheckAnalysis.new(update)
      if analysis.checkmate == true
        return true
      end
    end

    return true
  end

  def AutoPlay.get_game_strings(file)
    strings = File.readlines(file)
    strings.each {|string| string.chomp!}
    strings.delete("")

    return strings
  end

  def AutoPlay.process_game_strings(strings)
    matches = []
    strings.each { |string|
      moves = AutoPlay.get_moves(string)
      next if AutoPlay.contains_unusable_move(moves)
      matches.push(moves)
    }
    return matches
  end

  def AutoPlay.get_moves(string)
    moves = string.split
    return moves
  end

  def AutoPlay.contains_unusable_move(moves)
    if moves.any? { |move| move.length != 4 }
      return true
    else
      return false
    end
  end

  class AutoPlayTurn < Turn
    def initialize(game)
      @board = game.board
      @current_player = nil
      @enemy_player = nil
      assign_players(game)    
      @input = nil
    end
  end
end