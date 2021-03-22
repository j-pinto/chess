class Game
  attr_reader :move_list, :captured_pieces
  attr_accessor :turn_count, :board, :players
  def initialize
    @players = nil
    @board = nil
    @turn_count = 0
    @move_list = []
    @captured_pieces = []
  end

  def data_update(input, update)
    @turn_count += 1

    move = input.input_string.downcase
    @move_list.push(move)

    if update.captured_piece != nil
      @captured_pieces.push(update.captured_piece)
    end
  end
end