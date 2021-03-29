class GraphicsObj
  def initialize(game)
    @board = game.board
    @move_list = game.move_list
    @captured_pieces = game.captured_pieces

    @rank_labels = ['1','2','3','4','5','6','7','8']
    @file_labels = ['A','B','C','D','E','F','G','H']
    @rank_count = 7
    @file_count = 0
    @move_count = 0
    @move_label = 0
  end

  def print_moves
    moveset_title()
    newline()
    move_lines()
    newline()
    reset_counts()
  end

  def print_captures
    return if @captured_pieces.empty?
    puts "Captured Pieces: "
    types = [Queen, Rook, Bishop, Knight, Pawn]
    colors = ['white', 'black']

    colors.each { |color|
      types.each {|type|
        captured_piece_print(color, type)
      }

      newline()
    }
  end

  def captured_piece_print(color, type)
    @captured_pieces.each { |piece|
      next unless piece.class == type
      next unless piece.color == color
      print "#{piece.unicode}" 
    }
  end
  
  def print_board
    top_row()

    3.times {
      odd_row()
      even_row()
    }

    odd_row()
    file_print()

    reset_counts()
  end

  def top_row
    blank_strip_light_dark()
    newline()

    rank_print()
    piece_strip_light_dark()
    newline()

    blank_strip_light_dark()
    newline()

    @rank_count -= 1
    @file_count = 0
  end

  def odd_row
    blank_strip_dark_light()
    newline()

    rank_print()
    piece_strip_dark_light()
    newline()

    blank_strip_dark_light()
    newline()

    @rank_count -= 1
    @file_count = 0
  end

  def even_row
    blank_strip_light_dark()
    newline()

    rank_print()
    piece_strip_light_dark()
    newline()

    blank_strip_light_dark()
    newline()

    @rank_count -= 1
    @file_count = 0
  end

  def blank_strip_light_dark
    adjust_alignment()

    4.times {
      print "       ".on_light_black
      print "       ".on_black
    }

    spacer()
  end
  
  def blank_strip_dark_light
    adjust_alignment()

    4.times {
      print "       ".on_black
      print "       ".on_light_black
    }

    spacer()
  end
  
  def piece_strip_light_dark
    4.times {
      print "   #{print_piece()}   ".on_light_black
      @file_count += 1
      print "   #{print_piece()}   ".on_black
      @file_count += 1
    }

    spacer()
  end
  
  def piece_strip_dark_light
    4.times {
      print "   #{print_piece()}   ".on_black
      @file_count += 1
      print "   #{print_piece()}   ".on_light_black
      @file_count += 1
    }  

    spacer()
  end
  
  def print_piece
    if @board.grid[[@file_count, @rank_count]] == nil
      piece = " "
    else
      piece = @board.grid[[@file_count, @rank_count]].unicode
    end
  
    return piece
  end
  
  def file_print
    print "   "
  
    @file_labels.each { |letter| 
      print "   #{letter}   "
    }
  
    puts ""
  end
  
  def rank_print
    print "#{@rank_count + 1}  "
  end
  
  def adjust_alignment
    print "   "
  end

  def spacer
    print " "
  end
  
  def newline
    puts ""
  end
  
  def move_lines
    until ( @move_count > @move_list.size )
      4.times {
        return if @move_list[@move_count] == nil
        label_print()
        white_move_print()
        black_move_print()
        @move_count += 2
        @move_label += 1
      }
      newline()
    end
  end

  def label_print
    print "#{ @move_label + 1 }."

    if @move_label < 9
      print "  "
    else
      print " "
    end
  end

  def white_move_print
    print "#{ @move_list[@move_count] }"
  end

  def black_move_print
    if @move_list[@move_count + 1] != nil
      print "  #{@move_list[@move_count + 1]}"
    else
      print "      "
    end
    print " |"
  end

  def captured_row
    return if @captured_pieces.empty?

    print "Captured Pieces: "
    @captured_pieces.each { |piece|
      print "#{piece.unicode}"
    }
  end

  def moveset_title
    return if @move_list.empty?
    print "Past Move List:"
  end

  def reset_counts
    @rank_count = 7
    @file_count = 0
    @move_count = 0
    @move_label = 0
  end

  def clear
    print `clear`
  end
end




