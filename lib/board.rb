require './lib/bishop.rb'
require './lib/king.rb'
require './lib/knight.rb'
require './lib/pawn.rb'
require './lib/queen.rb'
require './lib/rook.rb'

class Board
  attr_reader :active_pieces
  
  def initialize
    @player = "White"
    @starting_positions = {
      :bishops => {:white => ["c1","f1"], :black => ["c8","f8"]},
      # :kings => {:white => ["e1"], :black => ["e8"]},
      :knights => {:white => ["b1","g1"], :black => ["b8","g8"]},
      # :pawns => {:white => ["a2","b2","c2","d2","e2","f2","g2","h2"], :black => ["a7","b7","c7","d7","e7","f7","g7","h7"]},
      # :queens => {:white => ["d1"], :black => ["d8"]},
      # :rooks => {:white => ["a1","h1"], :black => ["a8","h8"]}
    }
    @board = self.create_new_board
    @active_pieces = {
      :white => {
        :bishops => [],
        :kings => [],
        :knights => [],
        :pawns => [],
        :queens => [],
        :rooks => []
      },
      :black => {
        :bishops => [],
        :kings => [],
        :knights => [],
        :pawns => [],
        :queens => [],
        :rooks => []
      }
    }
  end
  
  def create_new_board
    new_board = {}
    
    ("a".."h").each do |letter|
      new_board[letter] = []
      (1..8).each do |number|
        new_board[letter] << "   "
      end
    end

    new_board
  end

  def show_board
    row_number = 8

    puts "   ---------------------------------"

    (@board.keys.length).times do |i|
      row_number = 8 - i
      print "#{row_number}  |"
      
      (@board.keys).each do |column|
        print "#{@board[column][row_number - 1]}|"
      end

      puts ""
      puts "   ---------------------------------"
    end
    
    puts "     a   b   c   d   e   f   g   h "
  end

  def create_pieces
    @starting_positions.each do |piece, hash|
      hash.each do |color, position_array|
        position_array.each do |position|
          color = color.to_sym
          piece = piece.to_sym

          case piece
          when :bishops
            @active_pieces[color][piece] << Bishop.new(color,position)
          when :kings
            @active_pieces[color][piece] << King.new(color,position)
          when :knights
            @active_pieces[color][piece] << Knight.new(color,position)
          when :pawns
            @active_pieces[color][piece] << Pawn.new(color,position)
          when :queens
            @active_pieces[color][piece] << Queen.new(color,position)
          when :rooks
            @active_pieces[color][piece] << Rook.new(color,position)
          else
            return "Error intializing game."
          end
        end
      end
    end
  end

  def set_board
    @active_pieces.each do |color, piece_type|
      piece_type.each do |type_name, piece_array|
        piece_array.each do |piece|
          set_piece(piece.token,piece.current_position)
        end
      end
    end
  end

  def get_move
    print "#{@player} player, please make your move: "
    
    while true do
      full_input = gets.chomp.split(' ')
      if (full_input.length == 2) && 
          (full_input[0].match(/^\w{1}\d{1}$/)) && 
          (full_input[1].match(/^\w{1}\d{1}$/))
        return full_input
      else
        puts "Error, selection not valid. Please try again."
      end
    end
  end

  def grab_piece(move)
    color = @player.downcase.to_sym
    to_move = ''

    @active_pieces[color].each do |type, pieces|
      pieces.each do |piece|
        if piece.current_position == move
          to_move = piece
          break
        end
      end
    end
    
    to_move
  end

  # Update this method to help with knight vs other pieces and if pieces are in the way of possible moves
  def check_move_legality(piece,destination)
    if piece.possible_moves.include? destination
      space_occupier = grab_piece(destination)
      
      if space_occupier == "" || space_occupier.color != @player.downcase.to_sym
        return true
      end
    end

    return false
  end

  def move_piece(piece, destination)
    set_piece(piece.token, destination, piece.current_position)
    piece.current_position = destination
    piece.possible_moves = piece.generate_possible_moves(destination)
    p piece
  end

  def set_piece(token, destination, position = nil)
    unless position == nil
      position = position.split('')
      @board[position[0]][position[1].to_i - 1] = "   "
    end

    destination = destination.split('')
    @board[destination[0]][destination[1].to_i - 1] = " #{token} "
  end





  def check_for_king
    # Check if king is in new move_set
    #if it is and the king has valid moves or its friendly pieces
    #     can block the path or take the piece applying pressure
    #   then return check
    # else check mate
    #on the reverse of this
    # if king cant move and no other piece can aid, return check mate
    # else return check
  end

  def change_player
    @player = (@player == "White") ? "Black" : "White"
  end
end






# all_piece_types = [:bishops,:kings,:knights,:pawns,:queens,:rooks]
# all_colors = [:white,:black]

# all_colors.each do |color|
#   all_piece_types.each do |unit|
#     board.active_pieces[color][unit].each {|piece| p piece}
#   end
# end