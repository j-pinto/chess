module Prompts
  def Prompts.intro
    puts "
    Welcome to Chess!"
    puts "
    (tip: for proper display of interface, set terminal to show
    at least 75 characters per line)"
    puts ""
  end

  def Prompts.instructions
    puts "    Game is designed for two players. Each player enters their 
    move when prompted in long algebraic format. Only enter the
    starting and ending square. Do not include any notation for
    the piece being moved, captures, or en passant.

      example: c1f4 (to move a piece from C1 to F4)

    For castling, only enter the movement of the king. 
    
      example: e8g8 (for a short castle by black king)

    For pawn promotion, there will be a separate prompt to select
    the new piece.

    These additional commands can be entered at any 
    input prompt during play:
      'DATA' - to see a list of captured pieces and past moves
      'SAVE' - to save your game and exit
      'EXIT' - to exit without saving
      'HELP' - to display these instructions"

    puts ""
  end

  def Prompts.new_game
    puts "
    To start a new game, enter 'NEW'. To load a previous game,
    enter 'LOAD'.To exit, enter 'EXIT'."
    puts ""
  end

  def Prompts.input
    puts "Enter Input: "
  end

  def Prompts.turn(color)
    puts "#{color.capitalize} To Move"
  end

  def Prompts.check
    puts ""
    puts "Check!"
  end

  def Prompts.promotion
    puts "Pawn Promotion!"
    puts "Enter Promotion Selection (Q, R, B, N): "
  end

  def Prompts.promotion_complete(piece)
    puts "Pawn promoted to #{piece.class}"
  end

  def Prompts.invalid_input
    puts "Input INVALID, please try again."
  end

  def Prompts.invalid_move
    puts "Move INVALID, please try again."
  end

  def Prompts.invalid_move_check
    puts "Move INVALID, would result in check. Please try again."
  end

  def Prompts.checkmate
    puts "Checkmate!"
  end

  def Prompts.winner(color)
    puts "#{color.capitalize} is the winner!"
  end

  def Prompts.enter_save_name
    puts "Enter name of file under which game will be saved: "
  end

  def Prompts.saved
    puts "Game saved successfully."
  end

  def Prompts.no_saved_games
    puts "Error: No saved games available"
    puts "Starting new game..."
  end

  def Prompts.display_saved_games
    puts "
    Enter number from list below corresponding to saved game you
    wish to load. Enter 'NEW' to start a new game. Enter 'EXIT' 
    to exit program"
    puts "
    List of saved games:"
    save_files = Dir.children("#{Dir.pwd}/saved_games/")
    save_files.each_index {|index| 
      puts "    #{index + 1}. #{save_files[index].to_s.slice(0..-5)}"
    }
    puts ""
  end

  def Prompts.load_name_error
    puts "
    Error: file does not exist"
  end

  def Prompts.new_game_success
    puts "New game started."
    puts ""
  end

  def Prompts.load_game_success(string)
    puts "#{string} loaded successfully."
    puts ""
  end

  def Prompts.clear
    print `clear`
  end
end