class Queen
  @@WHITE_PIECE = "\u265B"
  @@BLACK_PIECE = "\u2655"

  attr_accessor :current_position, :possible_moves, :token, :color
  
  def initialize(color, position)
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
  end

  def generate_possible_moves(pos)
    # Calculate diagonal moves from bishop code
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

    # Calculate vertical and horizontal moves from rook code
    cur_x = pos.split('')[0]
    cur_y = pos.split('')[1]

    ("a".."h").each { |letter| (move_set << letter + cur_y) unless letter == cur_x }
    (1..8).each { |number| (move_set << cur_x + number.to_s) unless number.to_s == cur_y }

    move_set
  end

  def traversed(destination)
    pos = @current_position.split('')
    des = destination.split('')

    if pos[0] == des[0] || pos[1] == des[1]
      if pos[0] == des[0]
        if pos[1] < des[1]
          to_move_through = (pos[1].to_i + 1..des[1].to_i - 1).map do |number|
            pos[0] + number.to_s
          end
        else
          to_move_through = (des[1].to_i + 1..pos[1].to_i - 1).map do |number|
            pos[0] + number.to_s
          end
          to_move_through = to_move_through.reverse
        end
      else
        if pos[0].ord < des[0].ord
          to_move_through = (pos[0].ord + 1..des[0].ord - 1).map do |letter|
            letter.chr + pos[1]
          end
        else
          to_move_through = ((des[0].ord + 1)..(pos[0].ord - 1)).map do |letter|
            letter.chr + pos[1]
          end
          to_move_through = to_move_through.reverse
        end
      end
    else
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
    end

    return to_move_through
  end
end