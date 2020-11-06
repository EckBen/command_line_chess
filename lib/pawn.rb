class Pawn
  @@WHITE_PIECE = "\u265F"
  @@BLACK_PIECE = "\u2659"

  attr_accessor :current_position, :possible_moves, :token, :color
  
  def initialize(color, position)
    @current_position = position
    @possible_moves = generate_possible_moves(position)
    @color = color
    @possible_moves = generate_possible_moves(position)
    @token = (color == :white) ? @@WHITE_PIECE : @@BLACK_PIECE
  end

  def generate_possible_moves(pos)
    
  end
end