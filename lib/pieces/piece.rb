class Piece
  attr_accessor :moved
  def initialize(color)
    @color = color
    @moved = false
  end

  def get_color
    @color  
  end
  
  def is_within_board(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def enemy_piece?(piece)
    return false if piece.nil?

    piece.get_color != @color
  end

  def friendly_piece?(piece)
    return false if piece.nil?

    piece.get_color == @color
  end

  def collect_moves_in_direction(current_position ,x_axis, y_axis, moves, board)
    loop do
      new_x = current_position[0] + x_axis 
      new_y = current_position[1] + y_axis 

      new_position = [new_x, new_y]

      if is_within_board(new_x, new_y) && board[new_x][new_y].nil?
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