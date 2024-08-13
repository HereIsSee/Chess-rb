class Rook
  def initialize(color)
    @color = color
  end

  def get_color
    @color  
  end

  def to_s
    return 'wr' if @color == 'white'
    return 'br' if @color == 'black'
    
    'error'
  end
end