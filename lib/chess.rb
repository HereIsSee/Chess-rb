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
  
  def set_up_board
    
  end


  def show_board
    7.downto(0) do |row_index|
      row = ''
      0.upto(7) do |col_index|
        value = @board[col_index][row_index] || '-'
        # value = col_index
        row = row.concat(value.to_s, ' ')
      end
      puts row
    end
    puts ''
  end

end