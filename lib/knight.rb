class Knight
  @@WHITE_PIECE = "\u265E"
  @@BLACK_PIECE = "\u2658"

  attr_accessor :current_position, :possible_moves, :token, :color
  
  def initialize(color, position)
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
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
end