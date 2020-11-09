class King
  @@WHITE_PIECE = "\u265A"
  @@BLACK_PIECE = "\u2654"

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

    (-1..1).each do |i|
      (-1..1).each do |j|
        new_x = (cur_x.ord + i)
        new_y = (cur_y.to_i + j)
        
        if new_x >= 97 && new_x <= 104 && new_y >= 1 && new_y <= 8
          move_set << (new_x.chr + new_y.to_s)
        end
      end
    end

    move_set.delete pos

    move_set
  end
end