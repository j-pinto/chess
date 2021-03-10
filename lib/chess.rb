require_relative 'required_files'

game = Game.new()

players = {
  'white' => Player.new('white'),
  'black' => Player.new('black')
}

board = Board.new()

game.board = board
game.players = players

Graphics.print_board(board)
