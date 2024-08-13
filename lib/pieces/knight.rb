require_relative 'piece'

class Knight < Piece
  
  KNIGHT_MOVES = [
  [2, 1], [2, -1], [-2, 1], [-2, -1],
  [1, 2], [1, -2], [-1, 2], [-1, -2]
  ]
  
  def initialize(color)
    @color = color
  end

  def get_moves(current_position, board)
    moves = []

    KNIGHT_MOVES.each do |move|
      new_x = current_position[0] + move[0]
      new_y = current_position[1] + move[1]
      
      new_position = [new_x, new_y]
      
      moves << new_position if is_within_board(new_x, new_y) && !friendly_piece?
    end

    moves
  end

  def get_color
    @color
  end
  
  def to_s
    return 'wn' if @color == 'white'
    return 'bn' if @color == 'black'
    
    'error'
  end


end