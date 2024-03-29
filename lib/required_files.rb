require 'colorize'

require_relative './main/board'
require_relative './main/game'
require_relative './main/graphics'
require_relative './main/input'
require_relative './main/player'
require_relative './main/turn'
require_relative './main/update'
require_relative './main/check_analysis'
require_relative './main/intro.rb'
require_relative './main/prompts.rb'
require_relative './main/save_load.rb'

require_relative './moves/move_type_selector'
require_relative './moves/move'
require_relative './moves/capture'
require_relative './moves/en_pass'
require_relative './moves/castle'

require_relative './pieces/piece'
require_relative './pieces/piece_constants'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/bishop'
require_relative './pieces/knight'
require_relative './pieces/rook'
require_relative './pieces/pawn'