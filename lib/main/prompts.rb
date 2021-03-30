module Prompts
  def Prompts.intro
    puts "
    Welcome to Chess!"
    puts "
    (tip: for proper display of interface, set terminal to show
    at least 75 characters per line)"
  end

  def Prompts.instructions
    puts "
    Game is designed for two players. Each player enters their 
    move when prompted in long algebraic format. Only enter the
    starting and ending square. Do not include any notation for
    the piece being moved, captures, or en passant.

      example: c1f4 (to move a piece from C1 to F4)

    For castling, only enter the movement of the king. 
    
      example: e8g8 (for a short castle by black king)

    For pawn promotion, there will be separate prompt to select
    the new piece.

    List of additional commands. These can be entered at any 
    input prompt during play:
      'DATA' - to see a list of captured pieces and past moves
      'SAVE' - to save the state of the current game
      'EXIT' - to exit the program
      'HELP' - to display these instructions"

    puts ""
  end

  def Prompts.new_game
    puts "To start a new game, enter 'NEW'. To exit, enter 'EXIT'."
    puts ""
  end

  def Prompts.input
    puts "Enter Input: "
  end

  def Prompts.turn(color)
    if color == 'white'
      puts "White To Move"
    else
      puts "Black To Move"
    end
  end

  def Prompts.invalid_input
    puts "Input INVALID, please try again."
  end
end