require_relative 'piece'

class Pawn < Piece
  attr_reader :en_passant
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
    @en_passant = false
  end
  
  def to_s
    return 'wp' if @color == 'white'
    return 'bp' if @color == 'black'
    
    'error'
  end

  def enable_en_passant
    @en_passant = true
  end

  def disable_en_passant
    @en_passant = false
  end

  def get_moves(current_position, board)
    moves = []

    pawn_moves = @color == 'white' ? WHITE_PAWN_MOVES : BLACK_PAWN_MOVES
    start_row = @color == 'white' ? 1 : 6
    
    # Check if the pawn is in the starting position
    if current_position[1] == start_row
      if @color == 'white' && board[current_position[0]][current_position[1]+1].nil?
        add_move_if_valid(current_position, pawn_moves[0], board, moves)
      elsif @color == 'black' && board[current_position[0]][current_position[1]-1].nil?
        add_move_if_valid(current_position, pawn_moves[0], board, moves)
      end
    end

    # Normal forward move
    add_move_if_valid(current_position, pawn_moves[1], board, moves)

    # Diagonal captures
    [pawn_moves[2], pawn_moves[3]].each do |diagonal_move|
      add_capture_if_valid(current_position, diagonal_move, board, moves)
    end

    moves
  end

  def get_attack_moves(current_position)
    moves = []

    pawn_moves = @color == 'white' ? WHITE_PAWN_MOVES : BLACK_PAWN_MOVES

    [pawn_moves[2], pawn_moves[3]].each do |move|
      new_x = current_position[0] + move[0]
      new_y = current_position[1] + move[1]
      if is_within_board(new_x, new_y)
        moves << [new_x, new_y]
      end
    end

    moves
  end
  
  private

  def add_move_if_valid(current_position, move, board, moves)
    new_x = current_position[0] + move[0]
    new_y = current_position[1] + move[1]
    if is_within_board(new_x, new_y) && board[new_x][new_y].nil?
      moves << [new_x, new_y]
    end
  end

  def add_capture_if_valid(current_position, move, board, moves)
    new_x = current_position[0] + move[0]
    new_y = current_position[1] + move[1]
    if is_within_board(new_x, new_y) && enemy_piece?(board[new_x][new_y])
      moves << [new_x, new_y]
    elsif en_passant_possible?(current_position, board, move[0])
      moves << [new_x, new_y]
    end
  end

  def en_passant_possible?(current_position, board, x_direction)
    enemy_pawn_position = [current_position[0]+x_direction, current_position[1]]

    is_an_enemy_pawn?(enemy_pawn_position, board) &&
    board[enemy_pawn_position[0]][enemy_pawn_position[1]].en_passant
  end

  def is_an_enemy_pawn?(position, board)
    is_within_board(position[0], position[1]) && !board[position[0]][position[1]].nil? &&
    board[position[0]][position[1]].is_a?(Pawn) && enemy_piece?(board[position[0]][position[1]])
  end
end
