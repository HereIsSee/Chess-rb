require_relative '../lib/pieces/queen'

describe Queen do

  describe '#get_moves' do
        
    subject(:queen_moves) { described_class.new('white') }
        
    it 'returns 21 moves when queen is placed in [0, 0] position on an empty board' do
      moves = queen_moves.get_moves([0, 0], 
      [["wr", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(21)
    end

    it 'returns 7 moves when placed in [0, 0] position and friendly piece blocks two directions' do
      moves = queen_moves.get_moves([0, 0], 
      [["wr", "", "", "", "", "", "", ""], 
      ["wp", "wp", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(7)
    end

    it 'returns 13 moves when placed in [1, 1] position and enemy pieces surround queen from four cardinal directions' do
      moves = queen_moves.get_moves([1, 1], 
      [["", "bp", "", "", "", "", "", ""], 
      ["bp", "wr", "bp", "", "", "", "", ""], 
      ["", "bp", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""], 
      ["", "", "", "", "", "", "", ""]]
      )
      expect(moves.count).to eq(13)
    end

  end

end