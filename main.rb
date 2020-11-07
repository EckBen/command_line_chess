require './lib/board.rb'

board = Board.new
board.create_pieces
board.set_board

# board.intro - welcome to game and explain intro, tell how to find chess rules

board.show_board

while true
  # Disposable
  p board.occupied_spaces
  
  move = board.get_move
  piece = board.grab_piece(move[0])
  
  if piece == ""
    p "You don't have a piece there."
    next
  elsif board.check_move_legality(piece, move[1])
    board.move_piece(piece, move[1])
  else
    p "That is an illegal move."
    next
  end

  # Call method to check for check mate or check (check_for_king)
    # If check mate
      # End game
    # Elsif check
      # Puts who is in check
    # End

  board.change_player
  
  taken_piece = board.grab_piece(move[1])
  
  if taken_piece != ""
    taken_piece.current_position = ""
  end

  board.show_board
end

# Need to add save logic
# Need to add load logic