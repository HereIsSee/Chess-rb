require_relative '../lib/pieces/knight'

describe Knight do

  describe '#get_moves' do
    subject(:knight_moves) { described_class.new('white') }

    it 'returns 8 moves when placed in [3, 3] position on an empty board' do
      moves = knight_moves.get_moves([3, 3], 
        [["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "wn", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(8)
    end

    it 'returns 8 moves when placed in [3, 3] position and 3 enemy pawns are in the way' do
      moves = knight_moves.get_moves([3, 3], 
        [["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "wn", "", "", "", ""], 
        ["", "", "", "", "", "bp", "", ""], 
        ["", "", "bp", "", "bp", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(8)
    end

    it 'returns 5 moves when placed in [3, 3] position and 3 friendly pawns are in the way' do
      moves = knight_moves.get_moves([3, 3], 
        [["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "wn", "", "", "", ""], 
        ["", "", "", "", "", "wp", "", ""], 
        ["", "", "wp", "", "wp", "", "", ""], 
        ["", "", "", "", "", "", "", ""], 
        ["", "", "", "", "", "", "", ""]]
        )
        expect(moves.count).to eq(5)
    end
  end

end