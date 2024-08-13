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
      position = player_choose_piece(player_number)

      

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
        puts 'This is not your piece! Try again!'
      end
    end
  end
  
  def player_piece?(player_number, piece)
    (player_number == 1 && piece.get_color == "white") ||
    (player_number == 2 && piece.get_color == "black")
  end
  

  def get_item_on_board(position) #position is made up of a letter a-h and a number 0-7
    indexes = position.split("")

    x_axis = indexes[0].downcase.ord - 'a'.ord
    y_axis = indexes[1].to_i

    return @board[x_axis][y_axis] if x_axis.between?(0, 7) && y_axis.between?(0, 7)
    nil
  end
  
  def set_up_board
    0.upto(7) do |col_index|
      @board[6][col_index] = Pawn.new('black')
    end

    0.upto(7) do |col_index|
      @board[1][col_index] = Pawn.new('white')
    end

    @board[0][0] = Rook.new('white')
    @board[0][7] = Rook.new('white')

    @board[7][0] = Rook.new('black')
    @board[7][7] = Rook.new('black')

    @board[0][1] = Knight.new('white')
    @board[0][6] = Knight.new('white')

    @board[7][1] = Knight.new('black')
    @board[7][6] = Knight.new('black')

    @board[0][2] = Bishop.new('white')
    @board[0][5] = Bishop.new('white')

    @board[7][2] = Bishop.new('black')
    @board[7][5] = Bishop.new('black')

    @board[0][3] = Queen.new('white')
    @board[0][4] = King.new('white')

    @board[7][3] = Queen.new('black')
    @board[7][4] = King.new('black')
  end


  def show_board
    7.downto(0) do |row_index|
      row = ''
      0.upto(7) do |col_index|
        value = @board[row_index][col_index] || '--'
        # value = col_index
        row = row.concat(value.to_s, ' ')
      end
      puts row_index.to_s + " |" + row
    end
    puts '   -----------------------'
    puts '   a  b  c  d  e  f  g  h '
  end

end