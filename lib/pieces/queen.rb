require_relative 'piece'

class Queen < Piece
  def initialize(color)
    @color = color
  end
  
  def to_s
    return 'wq' if @color == 'white'
    return 'bq' if @color == 'black'
    
    'error'
  end

  def get_moves(current_position, board)
    moves = []

    collect_moves_in_direction(current_position, 1, 0, moves, board)
    collect_moves_in_direction(current_position, -1, 0, moves, board)
    collect_moves_in_direction(current_position, 0, 1, moves, board)
    collect_moves_in_direction(current_position, 0, -1, moves, board)

    collect_moves_in_direction(current_position, 1, 1, moves, board)
    collect_moves_in_direction(current_position, -1, 1, moves, board)
    collect_moves_in_direction(current_position, 1, -1, moves, board)
    collect_moves_in_direction(current_position, -1, -1, moves, board)

    moves
  end
end