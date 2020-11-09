class Rook
  @@WHITE_PIECE = "\u265C"
  @@BLACK_PIECE = "\u2656"

  attr_accessor :current_position, :possible_moves, :token, :color, :has_not_moved
  
  def initialize(color, position)
    @has_not_moved = true
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
  end

  def generate_possible_moves(pos)
    cur_x = pos.split('')[0]
    cur_y = pos.split('')[1]
    move_set = []

    ("a".."h").each { |letter| (move_set << letter + cur_y) unless letter == cur_x }
    (1..8).each { |number| (move_set << cur_x + number.to_s) unless number.to_s == cur_y }

    move_set
  end

  def traversed(destination)
    pos = @current_position.split('')
    des = destination.split('')

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

    to_move_through
  end
end