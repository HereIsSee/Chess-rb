require_relative '../lib/pieces/rook'

describe Rook do

  describe '#get_moves' do
        
    subject(:rook_moves) { described_class.new('white') }
        
    it 'returns 14 moves when placed in [0, 0] position' do
      moves = rook_moves.get_moves([0, 0], 
      [["wr", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(14)
    end

    it 'returns 7 moves when placed in [0, 0] position and friendly piece blocks one direction' do
      moves = rook_moves.get_moves([0, 0], 
      [["wr", "", "", "", "", "", "", ""], 
      ["wp", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(7)
    end

    it 'returns 4 moves when placed in [1, 1] position and enemy pieces surround rook' do
      moves = rook_moves.get_moves([1, 1], 
      [["", "bp", "", "", "", "", "", ""], 
      ["bp", "wr", "bp", "", "", "", "", ""], 
      ["", "bp", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(4)
    end

  end

end