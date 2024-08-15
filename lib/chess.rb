require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

# Left to do:
# 4. Add stale mate DONE
# 5. Add en passant
# 6. Add castling


class Chess
  attr_reader :board
  def initialize(board = Array.new(8) { Array.new(8) })
    @board = board
  end

  def play
    set_up_board
    player_number = 1
    team_color = 'white'
    opposite_team_color = 'black'
    loop do
      puts "Current team: #{team_color} Enemy team: #{opposite_team_color}"
      puts "Player #{player_number} choose the piece you want to move:"
      show_board

      player_make_move(player_number)

      if checkmate?(get_king_position(opposite_team_color))
        puts "Player #{player_number} wins!"
        return
      end
      if stalemate?(get_king_position(opposite_team_color))
        puts "Stalemate!"
        return
      end

      remove_en_passant(opposite_team_color)

      player_number = player_number == 1 ? 2 : 1
      team_color = player_number == 1 ? 'white' : 'black'
      opposite_team_color = player_number == 1 ? 'black' : 'white'
    end
    puts 'Tie!'
  end

  def player_make_move(player_number)
    team_color = player_number == 1 ? 'white' : 'black'
    puts "You are in check!" if in_check?(get_king_position(team_color))
    
    loop do
      coordinates = gets.chomp
      position = coordintates_to_array_position(coordinates)
      piece = get_piece_on_board(position)

      moves = piece.get_moves(position, @board)
      filtered_moves = filter_moves_for_check(team_color, position, piece, moves)
      
      next unless piece_can_be_played?(team_color, piece, position, filtered_moves)
      
      # puts available_moves_to_s(moves) + " all moves"

      puts 'Choose move, or go back by writing "back"'
      puts available_moves_to_s(filtered_moves) + ", back"

      chosen_move_position = choose_move(filtered_moves)

      if chosen_move_position == 'back'
        puts "You went back! Choose piece to play."
        next
      end

      execute_move(position, chosen_move_position, piece)
      
      return
    end
  end
  
  def filter_moves_for_check(team_color, position, piece, moves)
    moves.map { |move| move unless move_puts_king_in_check?(team_color, piece, position, move) }.compact
  end

  def collect_enemy_attack_moves(team_color)
    moves = []
    
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        attack_moves = potential_threats_from_position(row_index, col_index, team_color)
        moves.concat( attack_moves ) if !attack_moves.nil?
      end
    end

    moves.uniq
  end

  def collect_all_friendly_moves(team_color)
    moves = []
    
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        if  !@board[row_index][col_index].nil? && @board[row_index][col_index].get_color == team_color
          all_moves = @board[row_index][col_index].get_moves([row_index, col_index], @board)
          filtered_moves = filter_moves_for_check(team_color, [row_index, col_index], @board[row_index][col_index], all_moves)
          moves.concat( filtered_moves ) unless filtered_moves.nil?
        end
      end
    end

    moves.uniq
  end

  def remove_en_passant(team_color)
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        piece = @board[row_index][col_index]
        if !piece.nil? && piece.is_a?(Pawn) && piece.get_color == team_color
          @board[row_index][col_index].disable_en_passant
        end
      end
    end
  end

  def potential_threats_from_position(row_index, col_index, team_color)
    if !@board[row_index][col_index].nil? && @board[row_index][col_index].get_color != team_color
      
      if @board[row_index][col_index].is_a?(Pawn)
        @board[row_index][col_index].get_attack_moves( [row_index, col_index] )
      else
        @board[row_index][col_index].get_moves( [row_index, col_index], @board )
      end
    
    end
  end
  
  def execute_move(starting_position, move, piece)
    piece.enable_en_passant if piece.is_a?(Pawn) && (starting_position[1]-move[1]).abs == 2

    if is_an_en_passant_move?(move, piece)
      @board[move[0]][move[1]-1] = nil if piece.get_color == 'white'
      @board[move[0]][move[1]+1] = nil if piece.get_color == 'black'
    end
    
    @board[starting_position[0]][starting_position[1]] = nil

    @board[move[0]][move[1]] = piece
  end

  def is_an_en_passant_move?(move, piece)
    color = piece.get_color
    return true if color == 'white' && @board[move[0]][move[1]-1].is_a?(Pawn) && @board[move[0]][move[1]-1].en_passant
    return true if color == 'black' && @board[move[0]][move[1]+1].is_a?(Pawn) && @board[move[0]][move[1]+1].en_passant

    false
  end

  def choose_move(moves)
    move_coordinates = moves.map { |move| array_position_to_coordinates(move) }
    
    loop do
      chosen_move = gets.chomp

      return coordintates_to_array_position(chosen_move) if move_coordinates.include?(chosen_move)
      return 'back' if chosen_move == 'back'
      puts 'Wrong input! Try again!'
    end
  end

  def available_moves_to_s(moves)
    moves.map { |move| array_position_to_coordinates(move)}.join(', ')
  end

  def piece_can_be_played?(team_color, piece, position, filtered_moves)
    if piece.nil?
      puts 'There is no piece in this location! Try again!'
      false
    elsif !player_piece?(team_color, piece)
      puts 'This is not your piece! Try again!'
      false
    elsif player_piece?(team_color, piece) && filtered_moves.count == 0
      puts 'This piece has no available moves, try a different one!'
      false
    else
      true
    end
  end

  def move_puts_king_in_check?(team_color, piece, position, move)
    simulation_board = Chess.new(@board.map(&:dup))

    simulation_board.execute_move(position, move, piece)

    simulation_board.in_check?(simulation_board.get_king_position(team_color))

  end

  def in_check?(king_position)
    return false unless @board[king_position[0]][king_position[1]].is_a?(King)
      
    team_color = @board[king_position[0]][king_position[1]].get_color

    return true if collect_enemy_attack_moves(team_color).include?(king_position)
    
    false
  end

  def checkmate?(king_position)
    return false unless @board[king_position[0]][king_position[1]].is_a?(King)
      
    team_color = @board[king_position[0]][king_position[1]].get_color

    moves = collect_all_friendly_moves(team_color)

    if moves.count == 0 && in_check?(get_king_position(team_color))
      return true
    end
    
    false
  end

  def stalemate?(king_position)
    return false unless @board[king_position[0]][king_position[1]].is_a?(King)
      
    team_color = @board[king_position[0]][king_position[1]].get_color

    moves = collect_all_friendly_moves(team_color)

    if moves.count == 0 && !in_check?(get_king_position(team_color))
      return true
    end
    
    false
  end

  def get_king_position(color)
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        if @board[row_index][col_index].is_a?(King) && @board[row_index][col_index].get_color == color
          return [row_index, col_index]
        end
      end
    end
  end

  def player_piece?(team_color, piece)
    (piece.get_color == team_color) || 
    (piece.get_color == team_color)
  end
  
  def get_piece_on_board(position) # position is an array of x and y elements
    return @board[position[0]][position[1]] if position[0].between?(0, 7) && position[1].between?(0, 7)
    nil
  end

  def place_piece_on_board(cordinates, piece) #position is made up of a letter a-h and a number 0-7
    position = coordintates_to_array_position(cordinates)

    @board[position[0]][position[1]] = piece if position[0].between?(0, 7) && position[1].between?(0, 7)
  end
  
  def coordintates_to_array_position(cordinates)
    indexes = cordinates.split("")
    
    [indexes[0].downcase.ord - 'a'.ord, indexes[1].to_i]
  end

  def array_position_to_coordinates(position)
    (position[0] + 'a'.ord).chr + position[1].to_s
  end

  def set_up_board
    0.upto(7) do |col_index|
      @board[col_index][6] = Pawn.new('black')
    end

    0.upto(7) do |col_index|
      @board[col_index][1] = Pawn.new('white')
    end

    @board[0][0] = Rook.new('white')
    @board[7][0] = Rook.new('white')

    @board[0][7] = Rook.new('black')
    @board[7][7] = Rook.new('black')

    @board[1][0] = Knight.new('white')
    @board[6][0] = Knight.new('white')

    @board[1][7] = Knight.new('black')
    @board[6][7] = Knight.new('black')

    @board[2][0] = Bishop.new('white')
    @board[5][0] = Bishop.new('white')

    @board[2][7] = Bishop.new('black')
    @board[5][7] = Bishop.new('black')

    @board[3][0] = Queen.new('white')
    @board[4][0] = King.new('white')

    @board[3][7] = Queen.new('black')
    @board[4][7] = King.new('black')
  end


  def show_board
    7.downto(0) do |y_index|
      row = ''
      0.upto(7) do |x_index|
        value = @board[x_index][y_index] || '--'
        # value = col_index
        row = row.concat(value.to_s, ' ')
      end
      puts y_index.to_s + " |" + row
    end
    puts '   -----------------------'
    puts '   a  b  c  d  e  f  g  h '
  end

end
