require_relative '../lib/pieces/bishop'

describe Bishop do

  describe '#get_moves' do
        
    context 'shows possible moves when bishop is in corner' do
      subject(:bishop_moves) { described_class.new('white') }
      
      it 'returns 7 moves when placed in [0, 0] position' do
        moves = bishop_moves.get_moves([0, 0], 
        [["wb", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        p moves
      end
    
    end
  end

end