class Bishop
  @@WHITE_PIECE = "\u265D"
  @@BLACK_PIECE = "\u2657"

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

  def traversed(destination)
    pos = @current_position.split('')
    des = destination.split('')

    if pos[0] > des[0]
      column = (des[0].ord + 1..pos[0].ord - 1).to_a.reverse
      
      to_move_through = (des[0].ord + 1..pos[0].ord - 1).map.with_index(1) do |letter, index|
        if pos[1] < des[1]
          column[index - 1].chr + (pos[1].to_i + index).to_s
        else
          column[index - 1].chr + (pos[1].to_i - index).to_s
        end
      end
    else
      to_move_through = (pos[0].ord + 1..des[0].ord - 1).map.with_index(1) do |letter, index|
        if pos[1] < des[1]
          letter.chr + (pos[1].to_i + index).to_s
        else
          letter.chr + (pos[1].to_i - index).to_s
        end
      end
    end
    
    to_move_through
  end
end