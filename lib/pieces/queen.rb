class Queen
  def initialize(color)
    @color = color
  end

  def get_color
    @color  
  end
  
  def to_s
    return 'wq' if @color == 'white'
    return 'bq' if @color == 'black'
    
    'error'
  end
end