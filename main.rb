require './lib/board.rb'

def intro
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
end

def load_game
  directory = Dir.pwd
  games = []
  files = Dir.glob("#{directory}/lib/saved_games/*.save_game")

  if files == []
    puts "No saved games detected. Starting new game..."
    board = Board.new
    board.create_pieces
    return board
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

  File.open("#{directory}/lib/saved_games/#{games[selection - 1]}.save_game","r") do |f|
    system("clear")
    return Marshal.load(f)
  end
end

def save_game(board)
  puts ""
  puts "Saving game..."
  puts ""
  print "What do you want to call this game?  "
  game_name = gets.chomp

  time = Time.new
  file_name = "#{game_name}.save_game"

  File.open("#{Dir.pwd}/lib/saved_games/#{file_name}","w+") do |f|
    Marshal.dump(board,f)
  end

  puts "Game saved. Thank you for playing!"
  exit
end

def play_game(board)
  while true
    move = board.get_move
  
    if move == 's'
      save_game(board)
    end
  
    piece = board.grab_piece(move[0])
  
    if piece == "" || board.player.downcase.to_sym != piece.color
      puts "You don't have a piece there."
      next
    elsif board.check_move_legality(piece, move[1])
      if board.in_check
        unless (board.check_breakers.include? [piece,move[1]])
          puts "You must get your king out of check!"
          next
        end
        board.check_breakers = []
      end
  
      if !(piece.is_a? (King)) && board.sacrificing_king(piece)
        puts "That would put you in check, choose a different move."
        next
      end
      
      taken_piece = board.grab_piece(move[1])
    
      if taken_piece != ""
        board.delete_captured(taken_piece)
      end
      
      board.move_piece(piece, move[1])
  
      if (piece.is_a? (Pawn)) && ((move[1].split('')[1] == "1") || (move[1].split('')[1] == "8"))
        board.promote_pawn(piece)
      end
    else
      puts "That is an illegal move."
      next
    end
  
    system("clear")

    board.show_board
    
    if board.check_for_check(piece)
      if board.check_for_mate(piece)
        puts "Check mate! #{board.player.to_s.capitalize} has won this game."
        break
      else
        puts "#{board.enemy.to_s.capitalize}'s king is now in check!"
      end
    end
    
    board.change_player
  end
end

def ask_new_or_load
  while true do
    new_or_load = gets.chomp.split('')[0].downcase
    if new_or_load == 'l' || new_or_load == 'load'
      return load_game()
    elsif new_or_load == 'n' || new_or_load == 'new'
      board = Board.new
      board.create_pieces
      return board
    else
      puts "Error, selection not valid. Please try again."
    end
  end
end

def post_game
  puts ""
  puts "Good Game."
  puts "Would you like to play again? (y/n)"

  new_or_end = gets.chomp.split('')[0].downcase
  if new_or_end == 'y' || new_or_end == 'yes'
    board = Board.new
    board.create_pieces
    return board
  else
    puts "Thank you for playing."
    exit
  end
end

# Main function
intro()
board = ask_new_or_load()

while true do
  board.set_board
  board.show_board
  play_game(board)
  board = post_game()
end