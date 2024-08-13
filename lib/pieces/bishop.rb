require_relative 'piece'
class Bishop < Piece
  def initialize(color)
    super(color)
  end

  def get_color
    @color  
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

  def collect_moves_in_direction(current_position ,x_axis, y_axis, moves, board)
    loop do
      new_x = current_position[0] + x_axis # here
      new_y = current_position[1] + y_axis # and here

      new_position = [new_x, new_y]

      if is_within_board(new_x, new_y) && board[new_x][new_y] == ''
        moves << new_position
        current_position = new_position
      elsif is_within_board(new_x, new_y) && enemy_piece?(board[new_x][new_y])
        moves << new_position
        break
      else
        break
      end
    end
  end
end