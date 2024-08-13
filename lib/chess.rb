require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

class Chess
  
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def play
    set_up_board
    player_number = 1
    loop do
      puts "Player #{player_number} choose the piece you want to move:"
      show_board

      coordinates = player_choose_piece(player_number)

      position = cordinates_to_array_position(coordinates)
      p get_item_on_board(coordinates) #.get_moves(position)
      
      board_to_string_array()


      player_number = player_number == 1 ? 2 : 1
    end
    puts 'Tie!'
  end

  def player_choose_piece(player_number)
    loop do
      position = gets.chomp
      piece = get_item_on_board(position)
      if piece.nil?
        puts 'There is no piece in this location! Try again!'
      elsif player_piece?(player_number, piece)
        return position
      else
        puts player_number
        puts 'This is not your piece! Try again!'
      end
    end
  end
  
  def player_piece?(player_number, piece)
    (player_number == 1 && piece.get_color == "white") || 
    (player_number == 2 && piece.get_color == "black")
    
  end
  
  

  def get_item_on_board(cordinates) #position is made up of a letter a-h and a number 0-7
    
    position = cordinates_to_array_position(cordinates)
    # p position
    return @board[position[0]][position[1]] if position[0].between?(0, 7) && position[1].between?(0, 7)
    nil
  end
  
  def cordinates_to_array_position(cordinates)
    indexes = cordinates.split("")
    
    [indexes[0].downcase.ord - 'a'.ord, indexes[1].to_i]
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
    new_thing = @board.map do |row|
      new_row = []
      0.upto(7) do |col_index|
        new_row.push(row[col_index].to_s)
      end
      new_row
    end

    p new_thing
  end

end