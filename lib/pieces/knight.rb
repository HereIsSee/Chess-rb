class Knight
  def initialize(color)
    @color = color
  end

  def get_color
    @color
  end
  
  def to_s
    return 'wn' if @color == 'white'
    return 'bn' if @color == 'black'
    
    'error'
  end
end