class King < Piece
  attr_accessor :in_check
  def initialize
    super
    @in_check = false
  end
end

class Pawn < Piece
  attr_reader :capture_moveset
  attr_accessor :en_pass_vulnerable
  def initialize
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

class Rook < Piece
  def initialize
    super
  end
end

class Bishop < Piece
  def initialize
    super
  end
end

class Queen < Piece
  def initialize
    super
  end
end

class Knight < Piece
  def initialize
    super
  end
end