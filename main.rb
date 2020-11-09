require './lib/board.rb'

puts ""
puts "Welcome to Commandline Chess!"
puts ""
puts "The first player will be white."
puts "The second player will be black."
puts ""
puts "You may save the game at the beginning of any turn."
puts "Just type 'save' and choose a name to save as."
puts ""
puts "To make a move type the coordinates of your piece then"
puts "   the coordinates of where you want it to move to."
puts ""
print "Would you like to start a (n)ew game or (l)oad an old one?  "

while true do
  new_or_load = gets.chomp.split('')[0].downcase
  if new_or_load == 'l' || new_or_load == 'load'
    DIRECTORY = Dir.pwd
    games = []
    files = Dir.glob("#{DIRECTORY}/*.save_game")

    if files == []
      puts "No saved games detected. Starting new game..."
      board = Board.new
      board.create_pieces
      break
    end

    files.each do |file|
      games.push(file.split('/')[-1].split('.')[0])
    end

    puts "Please choose the number of the game you would like to play."
    
    games.each_with_index {|game, i| puts "#{i + 1}: #{game}"}
    
    selection = gets.chomp.to_i
    
    until (selection <= games.length) && (selection >= 1)
      print "Please make a valid selection: "
      selection = gets.chomp.to_i
    end

    File.open("#{DIRECTORY}/#{games[selection - 1]}.save_game","r") do |f|
      board = Marshal.load(f)
    end

    break
  elsif new_or_load == 'n' || new_or_load == 'new'
    board = Board.new
    board.create_pieces
    break
  else
    puts "Error, selection not valid. Please try again."
  end
end

board.set_board
board.show_board

while true
  move = board.get_move

  if move == 's'
    puts ""
    puts "Saving game..."
    puts ""
    print "What do you want to call this game?  "
    game_name = gets.chomp

    time = Time.new
    file_name = "#{game_name}.save_game"

    File.open(file_name,"w+") do |f|
      Marshal.dump(board,f)
    end

    puts "Game saved. Thank you for playing!"
    exit
  end

  piece = board.grab_piece(move[0])

  if piece == "" || board.player.downcase.to_sym != piece.color
    p "You don't have a piece there."
    next
  elsif board.check_move_legality(piece, move[1])
    taken_piece = board.grab_piece(move[1])
  
    if taken_piece != ""
      taken_piece.current_position = ""
    end
    
    board.move_piece(piece, move[1])

    if (piece.is_a? (Pawn)) && ((move[1].split('')[1] == "1") || (move[1].split('')[1] == "8"))
      board.promote_pawn(piece)
    end
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
  board.show_board
end