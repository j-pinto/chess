module Graphics
  def Graphics.print_board(board)
    rank_labels = ['1','2','3','4','5','6','7','8']
    file_labels = ['A','B','C','D','E','F','G','H']
    rank_count = 7
    file_count = 0

    4.times {
      #print 1st row alternating light-dark squares (ex: A8-H8)
      Graphics.blank_strip_light_dark()
      Graphics.newline()
      Graphics.rank_print(rank_labels)
      Graphics.piece_strip_light_dark(board, file_count, rank_count)
      Graphics.newline()
      Graphics.blank_strip_light_dark()

      rank_count -= 1
      file_count = 0
      Graphics.newline()

      #print 2nd row alternating dark-light squares (ex: A7 to H7)
      Graphics.blank_strip_dark_light()
      Graphics.newline()
      Graphics.rank_print(rank_labels)
      Graphics.piece_strip_dark_light(board, file_count, rank_count)
      Graphics.newline()
      Graphics.blank_strip_dark_light()

      rank_count -= 1
      file_count = 0
      Graphics.newline()
    }

    Graphics.file_print(file_labels)
  end

  def Graphics.blank_strip_light_dark
    Graphics.alignment_adjust()
    4.times {
      print "       ".on_light_black
      print "       ".on_black
    }
  end

  def Graphics.blank_strip_dark_light
    Graphics.alignment_adjust()
    4.times {
      print "       ".on_black
      print "       ".on_light_black
    }
  end

  def Graphics.piece_strip_light_dark(board, file_count, rank_count)
    4.times {
      print "   #{Graphics.print_piece(board, file_count, rank_count)}   ".on_light_black
      file_count += 1
      print "   #{Graphics.print_piece(board, file_count, rank_count)}   ".on_black
      file_count += 1
    }
  end

  def Graphics.piece_strip_dark_light(board, file_count, rank_count)
    4.times {
      print "   #{Graphics.print_piece(board, file_count, rank_count)}   ".on_black
      file_count += 1
      print "   #{Graphics.print_piece(board, file_count, rank_count)}   ".on_light_black
      file_count += 1
    }  
  end

  def Graphics.print_piece(board, file_count, rank_count)
    if board.grid[[file_count, rank_count]] == nil
      piece = " "
    else
      piece = board.grid[[file_count, rank_count]].unicode
    end

    return piece
  end

  def Graphics.file_print(labels)
    print "   "
    labels = labels.reverse
    8.times { print "   #{labels.pop}   " }
    puts ""
  end

  def Graphics.rank_print(labels)
    print " #{labels.pop} "
  end

  def Graphics.alignment_adjust
    print "   "
  end

  def Graphics.newline
    puts ""
  end

end