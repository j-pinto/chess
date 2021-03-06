require_relative 'required_files'

game = Game.new
Graphics.print_board(game.board)
turn = Turn.new(game.turn_count, game.players)
input = Input.new