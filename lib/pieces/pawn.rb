require_relative 'piece'

class Pawn < Piece
  
  WHITE_PAWN_MOVES = [
    [0, 2], # If pawn has not moved from starting position
    [0,1], # Normal move
    [1,1], [-1,1] # Attack moves
  ]
  BLACK_PAWN_MOVES = [
    [0, -2], # If pawn has not moved from starting position
    [0, -1], # Normal move
    [1, -1], [-1, -1] # Attack moves
  ]
  

  def initialize(color)
    super(color)
  end

  def get_color
    @color  
  end
  
  def to_s
    return 'wp' if @color == 'white'
    return 'bp' if @color == 'black'
    
    'error'
  end

  def get_moves(current_position, board)
    moves = []

    pawn_moves = @color == 'white' ? WHITE_PAWN_MOVES : BLACK_PAWN_MOVES
    start_row = @color == 'white' ? 1 : 6
    
    # Check if the pawn is in the starting position
    if current_position[1] == start_row
      add_move_if_valid(current_position, pawn_moves[0], board, moves)
    end

    # Normal forward move
    add_move_if_valid(current_position, pawn_moves[1], board, moves)

    # Diagonal captures
    [pawn_moves[2], pawn_moves[3]].each do |diagonal_move|
      add_capture_if_valid(current_position, diagonal_move, board, moves)
    end

    moves
  end
  
  private

  def add_move_if_valid(current_position, move, board, moves)
    new_x = current_position[0] + move[0]
    new_y = current_position[1] + move[1]
    if is_within_board(new_x, new_y) && board[new_x][new_y] == ''
      moves << [new_x, new_y]
    end
  end

  def add_capture_if_valid(current_position, move, board, moves)
    new_x = current_position[0] + move[0]
    new_y = current_position[1] + move[1]
    if is_within_board(new_x, new_y) && enemy_piece?(board[new_x][new_y])
      moves << [new_x, new_y]
    end
  end
end
