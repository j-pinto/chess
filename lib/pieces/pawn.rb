class Pawn < Piece
  attr_reader :capture_moveset
  attr_accessor :en_pass_vulnerable
  def initialize(color, initial_location)
    super
    @en_pass_vulnerable = false
    @capture_moveset = get_pawn_capture_moveset(self)
  end

  def get_pawn_capture_moveset(pawn)
    if pawn.color == 'white'
      return [[1, 1], [-1, 1]]
    end
  
    if pawn.color == 'black'
      return [[1, -1], [-1, -1]]
    end
  end
end