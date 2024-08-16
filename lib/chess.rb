require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require 'json'

# Write some test for the important methods:
#   Write test for each piece class
#   Write test


class Chess
  attr_reader :board
  def initialize(board = Array.new(8) { Array.new(8) })
    @board = board
    @current_team_color = 'white'
    @opposite_team_color = 'black'
    @ai_enabled = false
  end

  def play
    set_up_board

    puts "If you want to load a previously saved game type (yes/y)"
    anwser = gets.chomp
    load_game() if anwser== 'yes' || anwser== 'y'

    puts "Type 'ai' if you want to play against a robot"
    anwser = gets.chomp
    @ai_enabled = true if anwser == 'ai'

    loop do

      puts "Current team: #{@current_team_color} Enemy team: #{@opposite_team_color}"
      puts "Team #{@current_team_color} choose the piece you want to move or save and leave the game by writing 'save':"
      show_board

      if @ai_enabled && @current_team_color == 'black'
        ai_make_move
      else
        return if player_make_move == 'game_saved'
      end
      
      if checkmate?(get_king_position(@opposite_team_color))
        puts "#{@current_team_color} team wins!"
        return
      end
      if stalemate?(get_king_position(@opposite_team_color))
        puts "Stalemate!"
        return
      end

      remove_en_passant(@opposite_team_color)

      @current_team_color = @current_team_color == 'white' ? 'black' : 'white' 
      @opposite_team_color = @current_team_color == 'white' ? 'black' : 'white'
    end
    puts 'Tie!'
  end

  def player_make_move
    team_color = @current_team_color
    puts "You are in check!" if in_check?(get_king_position(team_color))
    
    loop do
      coordinates = gets.chomp
      if coordinates == 'save'
        save
        return 'game_saved'
      end

      position = coordintates_to_array_position(coordinates)
      piece = get_piece_on_board(position)

      filtered_moves = generate_legal_moves(piece, position, team_color)
      
      next unless piece_can_be_played?(team_color, piece, position, filtered_moves)

      puts 'Choose move, or go back by writing "back"'
      puts available_moves_to_s(filtered_moves) + ", back"

      chosen_move_position = choose_move(filtered_moves)

      if chosen_move_position == 'back'
        puts "You went back! Choose piece to play."
        next
      end

      execute_move(position, chosen_move_position, piece, true)
      
      return
    end
  end

  def ai_make_move
    # Gather available pieces that can be moved and their positions
    # Choose at random a piece that can be moved
    # Choose at random a move that the piece will make
    # Execute that move
    color = @current_team_color
    movable_piece_positions = collect_movable_pieces_positions(color)
    
    p chosen_piece_position = movable_piece_positions[Random.rand(0..(movable_piece_positions.count - 1))]

    p moves = generate_legal_moves(@board[chosen_piece_position[0]][chosen_piece_position[1]], chosen_piece_position, color)

    p chosen_move = moves[Random.rand(0..(moves.count - 1))]

    execute_move(chosen_piece_position, chosen_move, @board[chosen_piece_position[0]][chosen_piece_position[1]], true)
  end

    
  def generate_legal_moves(piece, position, team_color)
    moves = piece.get_moves(position, @board)
    piece.get_castling_moves(position, @board, moves, collect_enemy_attack_moves(team_color)) if piece.is_a?(King)
    
    filter_moves_for_check(team_color, position, piece, moves)
  end
  
  def collect_movable_pieces_positions(color)
    movable_piece_positions = []
    
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        piece = @board[row_index][col_index]
        position = [row_index, col_index]
        if !piece.nil? &&  piece.get_color == color && generate_legal_moves(piece, position, color).count > 0
          movable_piece_positions << position
        end
      end
    end

    movable_piece_positions
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
  
  def execute_move(starting_position, move, piece, not_simulation = false)
    piece.moved = true if not_simulation
    piece.enable_en_passant if piece.is_a?(Pawn) && (starting_position[1]-move[1]).abs == 2

    if is_an_en_passant_move?(move, piece)
      @board[move[0]][move[1]-1] = nil if piece.get_color == 'white'
      @board[move[0]][move[1]+1] = nil if piece.get_color == 'black'
    end


    if not_simulation && piece.is_a?(Pawn) && piece.promotion?(move)
      piece = choose_promotion_piece(piece.get_color)
    end

    if is_a_castling_move?(starting_position, move, piece)
      rook_y_position = starting_position[1]
      rook_x_position = starting_position[0]-move[0] > 0 ? 0 : 7
      
      @board[rook_x_position+3][rook_y_position] = @board[rook_x_position][rook_y_position] if rook_x_position == 0 
      @board[rook_x_position-2][rook_y_position] = @board[rook_x_position][rook_y_position] if rook_x_position == 7

      @board[rook_x_position][rook_y_position] = nil
    end
    
    @board[starting_position[0]][starting_position[1]] = nil

    @board[move[0]][move[1]] = piece
  end

  def is_an_en_passant_move?(move, piece)
    color = piece.get_color
    return true if piece.is_a?(Pawn) && color == 'white' && @board[move[0]][move[1]-1].is_a?(Pawn) && @board[move[0]][move[1]-1].en_passant
    return true if piece.is_a?(Pawn) && color == 'black' && @board[move[0]][move[1]+1].is_a?(Pawn) && @board[move[0]][move[1]+1].en_passant

    false
  end

  def is_a_castling_move?(starting_position, end_position, piece)
    return true if piece.is_a?(King) && (starting_position[0]-end_position[0]).abs == 2

    false
  end

  def choose_promotion_piece(color)
    loop do
      puts "Choose a promotion piece:"
      puts "queen, rook, knight, bishop"
      decision = gets.chomp

      case decision
      when 'queen'
        return Queen.new(color, true)
      when 'rook'
        return Rook.new(color, true)
      when 'knight'
        return Knight.new(color, true)
      when 'bishop'
        return Bishop.new(color, true)
      else
        puts "Wrong input! Try again!"
      end
    end
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

  def remove_all_pieces_except(*args)
    0.upto(7) do |row_index|
      0.upto(7) do |col_index|
        @board[row_index][col_index] = nil if !args.include?([row_index, col_index])
      end
    end
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

  def load_game
    return puts 'No data saved previously!' if !File.exist?('save') || File.zero?('save')

    file_content = File.read('save')
    from_json(file_content)
  end

  def save
    File.write('save', to_json)
  end

  def to_json(*_args)
    JSON.dump({
                board: @board,
                current_team_color: @current_team_color,
                opposite_team_color: @opposite_team_color,
                ai_enabled: @ai_enabled
              })
  end

  def from_json(string)
    data = JSON.parse string
    @board = data['board'].map do |row|
      row.map do |piece_data|
        if piece_data.nil?
          nil
        else
          Object.const_get(piece_data['type']).from_json(piece_data) # line 370
        end
      end
    end
    @current_team_color = data['current_team_color']
    @opposite_team_color = data['opposite_team_color']
    @ai_enabled = data['ai_enabled']
  end

end
