module Graphics
  def Graphics.print_board(game)
    board = game.board
    rank_labels = ['1','2','3','4','5','6','7','8']
    file_labels = ['A','B','C','D','E','F','G','H']
    rank_count = 7
    file_count = 0
    movelist = game.move_list
    move_count = 0
    move_label = 0

    4.times {
      #print 1st row alternating light-dark squares (ex: A8-H8)
      Graphics.blank_strip_light_dark()
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
      Graphics.newline()

      Graphics.rank_print(rank_labels)
      Graphics.piece_strip_light_dark(board, file_count, rank_count)
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
      Graphics.newline()

      Graphics.blank_strip_light_dark()
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
      rank_count -= 1
      file_count = 0
      Graphics.newline()

      #print 2nd row alternating dark-light squares (ex: A7 to H7)
      Graphics.blank_strip_dark_light()
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
      Graphics.newline()

      Graphics.rank_print(rank_labels)
      Graphics.piece_strip_dark_light(board, file_count, rank_count)
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
      Graphics.newline()

      Graphics.blank_strip_dark_light()
      Graphics.move_line(move_count, move_label, movelist)
      move_count += 2
      move_label += 1
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

  def Graphics.move_line(count, label, list)
    return if list.empty?

    3.times {
      return if list[count] == nil

      print "#{label + 1}."
      if label < 9
        print "  "
      else
        print " "
      end
      print "#{list[count]}"

      if list[count + 1] != nil
        print "  #{list[count + 1]}"
      else
        print "      "
      end

      print " |"

      count += 48
      label += 24
    }
  end

end