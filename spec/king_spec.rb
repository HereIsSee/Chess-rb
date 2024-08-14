require_relative '../lib/pieces/king'

describe King do

  describe '#get_moves' do
        
    context 'basic king moves that involve only friendly pieces' do
      subject(:king_moves) { described_class.new('white') }
      
      it 'returns 3 moves when placed in [0, 0] position on an empty board' do
        moves = king_moves.get_moves([0, 0], 
        [["wk", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(3)
      end

      it 'returns 8 moves when placed in [1, 1] position on an empty board' do
        moves = king_moves.get_moves([1, 1], 
        [["", "", "", "", "", "", "", ""], 
        ["", "wk", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(8)
      end

      it 'returns 0 moves when placed in [1, 1] position and surrounded by friendly pieces' do
        moves = king_moves.get_moves([1, 1], 
        [["wp", "wp", "wp", "", "", "", "", ""], 
        ["wp", "wk", "wp", "", "", "", "", ""], 
        ["wp", "wp", "wp", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(0)
      end
    end
  end

end