require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

# Left to do:
# 1. Add restriction on king moves depending if the square is being # DOING
# attacked by enemy piece
# 2. Add checking
# 3. Add mating
# 4. Add restriction on all current player pieces that if moved would
# make current player king be in check
# 5. Add en passant


class Chess
  attr_reader :board
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def play
    set_up_board
    player_number = 1
    loop do
      puts "Player #{player_number} choose the piece you want to move:"
      show_board

      player_make_move(player_number)

      player_number = player_number == 1 ? 2 : 1
    end
    puts 'Tie!'
  end

  def player_make_move(player_number)
    loop do
      coordinates = gets.chomp
      position = coordintates_to_array_position(coordinates)
      piece = get_piece_on_board(position)
      
      flag = piece_can_be_played?(player_number, piece, position)

      next if !flag

      moves = piece.get_moves(position, board_to_string_array())

      # Filtering out moves that would cause to check your king
      filtered_moves = filter_moves_for_check(player_number, position, piece, moves)
      puts available_moves_to_s(filtered_moves)

      puts 'Choose move, or go back by writing "back"'
      puts available_moves_to_s(moves) + ", back"

      chosen_move_position = choose_move(moves)

      if chosen_move_position == 'back'
        puts "You went back! Choose piece to play."
        next
      end

      execute_move(position, chosen_move_position, piece)
      
      return
    end
  end
  
  def filter_moves_for_check(player_number, position, piece, moves)
    player_color = player_number == 1 ? 'white' : 'black'
    enemy_moves = collect_enemy_attack_moves(player_color)

    if piece.is_a?(King) 
      moves.map { |move| move if !enemy_moves.include?(move) }.compact
    else # every other piece
      # will need to update this so that it removes moves that would make king be placed in check
      moves
    end
    
  end

  def collect_enemy_attack_moves(player_color)
    moves = []
    
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        attack_moves = potential_threats_from_position(row_index, col_index, player_color)
        moves.concat( attack_moves ) if !attack_moves.nil?
      end
    end

    moves.uniq
  end

  def potential_threats_from_position(row_index, col_index, player_color)
    if !@board[row_index][col_index].nil? && @board[row_index][col_index].get_color != player_color
      
      if @board[row_index][col_index].is_a?(Pawn)
        @board[row_index][col_index].get_attack_moves( [row_index, col_index] )
      else
        @board[row_index][col_index].get_moves( [row_index, col_index], board_to_string_array )
      end
    
    end
  end
  
  def execute_move(starting_position, move, piece)
    @board[starting_position[0]][starting_position[1]] = nil

    @board[move[0]][move[1]] = piece
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

  def piece_can_be_played?(player_number, piece, position)
    if piece.nil?
      puts 'There is no piece in this location! Try again!'
      false
    elsif !player_piece?(player_number, piece)
      puts 'This is not your piece! Try again!'
      false
    elsif player_piece?(player_number, piece) && piece.get_moves(position, board_to_string_array()).count == 0
      puts 'This piece has no available moves, try a different one!'
      false
    else
      true
    end
  end

  def player_piece?(player_number, piece)
    (player_number == 1 && piece.get_color == "white") || 
    (player_number == 2 && piece.get_color == "black")
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

  def board_to_string_array
    @board.map do |row|
      new_row = []
      0.upto(7) do |col_index|
        new_row.push(row[col_index].to_s)
      end
      new_row
    end
  end

end
