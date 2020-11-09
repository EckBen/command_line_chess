require './lib/bishop.rb'
require './lib/king.rb'
require './lib/knight.rb'
require './lib/pawn.rb'
require './lib/queen.rb'
require './lib/rook.rb'

class Board
  attr_reader :active_pieces, :occupied_spaces, :player
  
  def initialize
    @en_passantable = ['',0]
    @player = "White"
    @starting_positions = {
      :bishops => {:white => ["c1","f1"], :black => ["c8","f8"]},
      :kings => {:white => ["e1"], :black => ["e8"]},
      :knights => {:white => ["b1","g1"], :black => ["b8","g8"]},
      :pawns => {:white => ["a2","b2","c2","d2","e2","f2","g2","h2"], :black => ["a7","b7","c7","d7","e7","f7","g7","h7"]},
      :queens => {:white => ["d1"], :black => ["d8"]},
      :rooks => {:white => ["a1","h1"], :black => ["a8","h8"]}
    }
    @occupied_spaces = []
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
    @CASTLE_SPACES = {
      "c1" => {
        "rook" => "a1",
        "rook_des" => "d1",
        "no_pressure" => ["c1","d1","e1"],
        "no_pieces" => ["b1","c1","d1"]
      },
      "g1" => {
        "rook" => "h1",
        "rook_des" => "f1",
        "no_pressure" => ["g1","f1","e1"],
        "no_pieces" => ["f1","g1"]
      },
      "c8" => {
        "rook" => "a8",
        "rook_des" => "d8",
        "no_pressure" => ["c8","d8","e8"],
        "no_pieces" => ["b8","c8","d8"]
      },
      "g8" => {
        "rook" => "h8",
        "rook_des" => "f8",
        "no_pressure" => ["g8","f8","e8"],
        "no_pieces" => ["f8","g8"]
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
      
      return 's' if full_input[0].downcase == 's' || full_input[0].downcase == 'save'

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
    to_move = ''

    @active_pieces.each do |color,type_hash|
      type_hash.each do |type, pieces|
        pieces.each do |piece|
          if piece.current_position == move
            return piece
          end
        end
      end
    end

    
    to_move
  end

  def check_move_legality(piece,destination)
    if @en_passantable[0] != '' && @en_passantable[1] == 0
      @en_passantable[1] = 1
    else
      @en_passantable = ['',0]
    end

    if piece.possible_moves.include? destination
      space_occupier = grab_piece(destination)

      if piece.is_a? (Pawn)
        des_col = destination.split('')[0]
        des_row = destination.split('')[1].to_i
        cur_col = piece.current_position.split('')[0]
        cur_row = piece.current_position.split('')[1].to_i

        if (cur_row - des_row).abs() > 1
          traversed_space = des_col + (des_row + 1).to_s
          
          unless (@occupied_spaces.include? traversed_space) || (occupied_spaces.include? destination)
            @en_passantable = [piece,0]
            return true
          end
        elsif (cur_row - des_row).abs() == 1 && cur_col == des_col
          unless (occupied_spaces.include? destination)
            return true
          end
        else
          if space_occupier == ""
            if legal_en_passant(piece,des_col,des_row)
              taken_piece = @en_passantable[0].current_position.split('')
              @occupied_spaces.delete(taken_piece.join)
              @board[taken_piece[0]][taken_piece[1].to_i - 1] = "   "
              @en_passantable[0].current_position = ''
              @en_passantable = ['',0]
              
              return true
            end
          else
            if space_occupier.color != @player.downcase.to_sym
              return true
            end
          end
        end

      elsif space_occupier == "" || space_occupier.color != @player.downcase.to_sym
        
        if (piece.is_a? (Knight))
          return true
        elsif (piece.is_a? (Queen)) || (piece.is_a? (Bishop)) || (piece.is_a? (Rook))
          moves_through = piece.traversed(destination)

          moves_through.each do |space|
            return false if @occupied_spaces.include? space
          end

          return true
        elsif (piece.is_a? (King))
          return true if !(pressure_on_space(destination))
        end
      end
    elsif (piece.is_a? (King)) && (@CASTLE_SPACES.keys.include? destination)
      return castle(piece,destination)
    end

    return false
  end

  def castle(piece,destination)
    rook = grab_piece(@CASTLE_SPACES[destination]["rook"])
        
    return false if rook == ""
    return false if piece.has_not_moved == false || rook.has_not_moved == false

    @CASTLE_SPACES[destination]["no_pieces"].each do |space|
      return false if @occupied_spaces.include? space
    end

    @CASTLE_SPACES[destination]["no_pressure"].each do |space|
      return false if pressure_on_space(space)
    end

    move_piece(rook,@CASTLE_SPACES[destination]["rook_des"])
    return true
  end

  def pressure_on_space(destination)
    temp_piece = Knight.new(@player.downcase.to_sym,destination)

    self.change_player
    opposing_player = @player.downcase.to_sym
    self.change_player

    @active_pieces[opposing_player].each do |piece_type, piece_array|
      if piece_type == :kings
        if (piece_array[0].possible_moves.include? destination)
          return true
        else
          next
        end
      end
      
      piece_array.each do |opposing_piece|
        if opposing_piece.current_position == ''
          next
        elsif check_move_legality(opposing_piece,destination)
          temp_piece.current_position = ''
          return true
        end
      end
    end

    return false
  end

  def move_piece(piece, destination)
    if (piece.is_a? (Pawn)) || (piece.is_a? (Rook)) || (piece.is_a? (King))
      piece.has_not_moved = false
    end

    set_piece(piece.token, destination, piece.current_position)
    piece.current_position = destination
    piece.possible_moves = piece.generate_possible_moves(destination)
  end

  def set_piece(token, destination, position = nil)
    unless position == nil
      @occupied_spaces.delete(position)
      position = position.split('')
      @board[position[0]][position[1].to_i - 1] = "   "
    end

    unless @occupied_spaces.include? destination
      @occupied_spaces << destination
    end

    destination = destination.split('')
    @board[destination[0]][destination[1].to_i - 1] = " #{token} "
  end

  def legal_en_passant(piece,des_col,des_row)
    if piece.color == :white
      single = -1
    else
      single = 1
    end
    
    if @en_passantable[0] != "" && (grab_piece(des_col + (des_row + single).to_s) == @en_passantable[0])
      return true
    else
      return false
    end
  end

  def promote_pawn(piece)
    p "Your pawn has earned a promotion. Would you like a:"
    p "[1] Queen"
    p "[2] Rook"
    p "[3] Bishop"
    p "[4] Knight"
    
    choice = ''
    coordinates = piece.current_position
    piece.current_position = ''
    
    while choice == '' do
      choice = gets.chomp.split(' ')[0]
      
      case choice
      when "1"
        @active_pieces[@player.downcase.to_sym][:queens] << Queen.new(@player.downcase.to_sym,coordinates)
        set_piece(@active_pieces[@player.downcase.to_sym][:queens][-1].token,coordinates)
      when "2"
        @active_pieces[@player.downcase.to_sym][:rooks] << Rook.new(@player.downcase.to_sym,coordinates)
        set_piece(@active_pieces[@player.downcase.to_sym][:rooks][-1].token,coordinates)
      when "3"
        @active_pieces[@player.downcase.to_sym][:bishops] << Bishop.new(@player.downcase.to_sym,coordinates)
        set_piece(@active_pieces[@player.downcase.to_sym][:bishops][-1].token,coordinates)
      when "4"
        @active_pieces[@player.downcase.to_sym][:knights] << Knight.new(@player.downcase.to_sym,coordinates)
        set_piece(@active_pieces[@player.downcase.to_sym][:knights][-1].token,coordinates)
      else
        puts "Error, selection not valid. Please try again."
        choice = ''
      end
    end
  end

  def change_player
    @player = (@player == "White") ? "Black" : "White"
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

  
end






# all_piece_types = [:bishops,:kings,:knights,:pawns,:queens,:rooks]
# all_colors = [:white,:black]

# all_colors.each do |color|
#   all_piece_types.each do |unit|
#     board.active_pieces[color][unit].each {|piece| p piece}
#   end
# end