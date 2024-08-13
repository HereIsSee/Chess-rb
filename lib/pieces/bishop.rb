class Bishop
  def initialize(color)
    @color = color
  end

  def to_s
    return 'wb' if @color == 'white'
    return 'bb' if @color == 'black'
    
    'error'
  end
end