class Bishop
  @@WHITE_PIECE = "\u265D"
  @@BLACK_PIECE = "\u2657"

  attr_accessor :current_position, :possible_moves, :token, :color
  
  def initialize(color, position)
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @possible_moves = generate_possible_moves(position)
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
  end

  def generate_possible_moves(pos)
    cur_x = pos.split('')[0].ord - "a".ord + 1
    cur_y = pos.split('')[1].to_i
    move_set = []

    (1..7).each do |i|
      if cur_x + i <= 8
        if cur_y + i <= 8
          move_set << [(cur_x + i + "a".ord - 1).chr, (cur_y + i).to_s].join
        end

        if cur_y - i >= 1
          move_set << [(cur_x + i + "a".ord - 1).chr, (cur_y - i).to_s].join
        end
      end

      if cur_x - i >= 1
        if cur_y -i >= 1
          move_set << [(cur_x - i + "a".ord - 1).chr, (cur_y - i).to_s].join
        end

        if cur_y + i <= 8
          move_set << [(cur_x - i + "a".ord - 1).chr, (cur_y + i).to_s].join
        end
      end
    end

    move_set
  end
end