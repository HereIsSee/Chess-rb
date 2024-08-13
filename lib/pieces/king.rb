class King
  def initialize(color)
    @color = color
  end

  def get_color
    @color  
  end
  
  def to_s
    return 'wk' if @color == 'white'
    return 'bk' if @color == 'black'
    
    'error'
  end
end