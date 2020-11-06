class Knight
  @@WHITE_PIECE = "\u2658"
  @@BLACK_PIECE = "\u265E"
  @@active_pieces = {"white"=>[],"black"=>[]}

  attr_reader :current_position, :possible_moves
  
  def initialize(color, position)
    @@active_pieces[color] << position
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @other_color = (color == "white") ? "black" : "white"
    @token = (color == "black") ? @@WHITE_PIECE : @@BLACK_PIECE
  end

  def generate_possible_moves(pos)
    cur_x = pos.split('')[0].ord - "a".ord + 1
    cur_y = pos.split('')[1].to_i
    x = cur_x + 2
    y = cur_y + 2
    move_set = []

    5.times do
      if x > 8 || x < 1
        x -= 1
        next
      end

      if x != cur_x 
        5.times do
          if y > 8 || y < 1
            y -= 1
            next
          end
          
          if x == cur_x - 1 || x == cur_x + 1
            if y == cur_y - 2 || y == cur_y + 2
              move_set << [(x + "a".ord - 1).chr, y.to_s].join
            end
          else
            if y == cur_y + 1 || y == cur_y - 1
              move_set << [(x + "a".ord - 1).chr, y.to_s].join
            end
          end

          y -= 1
        end
        
        y = cur_y + 2
      end
      
      x -= 1
    end

    move_set
  end

  def check_move_legality(destination)
    !(@@active_pieces[@color].include? destination) && (@possible_moves.include? destination)
  end

  def move_piece(destination)
    if self.check_move_legality(destination)
      @@active_pieces[@color].delete(@current_position)
      @@active_pieces[@color] << destination
      
      @current_position = destination

      @possible_moves = self.generate_possible_moves(@current_position)

      self.capture_enemy_piece(destination) if @@active_pieces[@other_color].include? destination

      return "move made"
    else
      return "Illegal move."
    end
  end

  def capture_enemy_piece(destination)
    # Figure out way to delete enemy piece
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