require_relative 'piece'

class King < Piece
  
  KING_MOVES = [
  [0, 1], [0, -1],
  [1, 0], [-1, 0],
  [1, 1], [-1, 1],
  [1, -1], [-1, -1]
  ]
  KING_CASTLING_MOVES = [
    [-2, 0], [2, 0]
  ]
  
  def initialize(color)
    super(color)
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

  def castling_available?(king_position, rook_position, board)
    spaces_that_need_to_be_empty = (king_position[0] - rook_position[0]) > 0 ? [1, 2, 3] : [5, 6]
    y_position = @color == 'white' ? 0 : 7

    spaces_that_need_to_be_empty.all? { |x_position| board[x_position][y_position].nil?} &&
    !board[king_position[0]][king_position[1]].moved &&
    !board[rook_position[0]][rook_position[1]].moved
  end

  def get_castling_moves(king_position, board, moves)
    row_to_check = @color == 'white' ? 0 : 7
    
    [[0, row_to_check], [7, row_to_check]].each do |possible_rook_position|
      if board[possible_rook_position[0]][possible_rook_position[1]].is_a?(Rook) && castling_available?(king_position, possible_rook_position, board)

        direction = (king_position[0] - possible_rook_position[0]) > 0 ? 0 : 1

        new_x = king_position[0] + KING_CASTLING_MOVES[direction][0]
        new_y = king_position[1] + KING_CASTLING_MOVES[direction][1]

        new_position = [new_x, new_y]

        if is_within_board(new_x, new_y) && !friendly_piece?(board[new_x][new_y])
          moves << new_position 
        end
      end
    end
  end
end