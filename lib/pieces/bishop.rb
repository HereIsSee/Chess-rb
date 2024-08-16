require_relative 'piece'
class Bishop < Piece
  def initialize(color, moved = false)
    super(color, moved)
  end
  
  def to_s
    return 'wb' if @color == 'white'
    return 'bb' if @color == 'black'
    
    'error'
  end

  def get_moves(current_position, board)
    moves = []

    collect_moves_in_direction(current_position, 1, 1, moves, board)
    collect_moves_in_direction(current_position, -1, 1, moves, board)
    collect_moves_in_direction(current_position, 1, -1, moves, board)
    collect_moves_in_direction(current_position, -1, -1, moves, board)

    moves
  end
end