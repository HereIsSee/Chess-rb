class Piece
  
  def initialize(color)
    @color = color
  end

  def is_within_board(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def enemy_piece?(piece)
    return false if piece == ''
    piece_color = piece.split('')
    piece_color = piece_color[0] == 'w' ? 'white' : 'black'
    piece_color != @color
  end
end