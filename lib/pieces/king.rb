require_relative 'piece'

class King < Piece
  
  KING_MOVES = [
  [0, 1], [0, -1],
  [1, 0], [-1, 0],
  [1, 1], [-1, 1],
  [1, -1], [-1, -1]
  ]
  
  def initialize(color)
    @color = color
  end
  
  def to_s
    return 'wk' if @color == 'white'
    return 'bk' if @color == 'black'
    
    'error'
  end

  def get_moves(current_position, board)
    moves = []

    KING_MOVES.each do |move|
      new_x = current_position[0] + move[0]
      new_y = current_position[1] + move[1]
      
      new_position = [new_x, new_y]
      
      moves << new_position if is_within_board(new_x, new_y) && !friendly_piece?(board[new_x][new_y])
    end

    moves
  end
end