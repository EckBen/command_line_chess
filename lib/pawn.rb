class Pawn
  @@WHITE_PIECE = "\u265F"
  @@BLACK_PIECE = "\u2659"

  attr_accessor :current_position, :possible_moves, :token, :color, :has_not_moved
  
  def initialize(color, position)
    @has_not_moved = true
    @color = color
    @current_position = position
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
    @possible_moves = generate_possible_moves(position)
  end

  def generate_possible_moves(pos)
    if @color == :white
      single = 1
      double = 2
    else
      single = -1
      double = -2
    end

    cur_x = pos.split('')[0]
    cur_y = pos.split('')[1].to_i
    move_set = []

    move_set << cur_x + (cur_y + single).to_s
    (move_set << (cur_x + (cur_y + double).to_s)) if @has_not_moved == true

    
    (move_set << ((cur_x.ord + 1).chr + (cur_y + single).to_s)) if cur_x != "h"
    (move_set << ((cur_x.ord - 1).chr + (cur_y + single).to_s)) if cur_x != "a"

    move_set
  end
end