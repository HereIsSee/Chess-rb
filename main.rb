require_relative 'lib/chess'

board = Chess.new
board.place_piece_on_board('a0', Bishop.new("white"))
p board.board_to_string_array