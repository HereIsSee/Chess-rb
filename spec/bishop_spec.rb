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
        expect(moves.count).to eq(7)
      end

      it 'returns 0 moves when white bishop is placed in [0, 0] position and in position [1, 1] is a white pawn' do
        moves = bishop_moves.get_moves([0, 0], 
        [["wb", "", "", "", "", "", "", ""],
        ["", "wp", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(0)
      end
      
      it 'returns 9 moves when placed in [1, 1] position' do
        moves = bishop_moves.get_moves([1, 1], 
        [["", "", "", "", "", "", "", ""], 
        ["", "wb", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(9)
      end
    end
  end

end