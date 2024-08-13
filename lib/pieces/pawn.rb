class Pawn
  
  def initialize(color)
    @color = color
  end

  def to_s
    return 'wp' if @color == 'white'
    return 'bp' if @color == 'black'
    
    'error'
  end
end