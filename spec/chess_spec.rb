require_relative '../lib/chess'

describe Chess do
  subject(:chess) { described_class.new }

  describe '#generate_legal_moves' do
    before do
      chess.set_up_board
    end

    context 'generate legal moves for pawn' do
      it 'allows a white pawn to move forward one space' do
        position = [0, 1] # Position of a white pawn
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'white')
        expect(moves).to include([0, 2])
      end

      it 'allows a black pawn to move forward one space' do
        position = [0, 6] # Position of a black pawn
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'black')
        expect(moves).to include([0, 5])
      end

      it 'allows a white pawn to move forward two spaces from starting position' do
        position = [1, 1]
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'white')
        expect(moves).to include([1, 3])
      end

      it 'allows a black pawn to move forward two spaces from starting position' do
        position = [1, 6]
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'black')
        expect(moves).to include([1, 4])
      end

      it 'allows a white pawn to capture diagonally' do
        chess.place_piece_on_board('b2', Pawn.new('black'))
        position = [0, 1] # Position of a white pawn
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'white')
        expect(moves).to include([1, 2])
      end

      it 'allows a black pawn to capture diagonally' do
        chess.place_piece_on_board('b5', Pawn.new('white'))
        position = [0, 6] # Position of a black pawn
        pawn = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(pawn, position, 'black')
        expect(moves).to include([1, 5])
      end
    end

    context 'generate legal moves for rook' do
      it 'allows a rook to move vertically and horizontally' do
        position = [0, 0] # Position of a white rook
        rook = chess.board[position[0]][position[1]]
        chess.remove_all_pieces_except([position])
        moves = chess.generate_legal_moves(rook, position, 'white')
        expected_moves = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'generate legal moves for knight' do
      it 'allows a knight to move in an L shape' do
        position = [1, 0] # Position of a white knight
        knight = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(knight, position, 'white')
        expected_moves = [[0, 2], [2, 2]]
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'generate legal moves for bishop' do
      it 'allows a bishop to move diagonally' do
        position = [2, 0] # Position of a white bishop
        bishop = chess.board[position[0]][position[1]]
        chess.remove_all_pieces_except([position])
        moves = chess.generate_legal_moves(bishop, position, 'white')
        expected_moves = [[1, 1], [0, 2], [3, 1], [4, 2], [5, 3], [6, 4], [7, 5]]
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'generate legal moves for queen' do
      it 'allows a queen to move vertically, horizontally, and diagonally' do
        position = [3, 0] # Position of a white queen
        queen = chess.board[position[0]][position[1]]
        chess.remove_all_pieces_except([position])
        moves = chess.generate_legal_moves(queen, position, 'white')
        expected_moves = [
          [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7],
          [4, 1], [5, 2], [6, 3], [7, 4], [2, 1], [1, 2], [0, 3],
          [2, 0], [1, 0], [0, 0], [4, 0], [5, 0], [6, 0], [7, 0]
        ]
        expect(moves).to match_array(expected_moves)
      end
    end

    context 'generate legal moves for king' do
      it 'allows a king to move one square in any direction' do
        position = [4, 0] # Position of a white king
        king = chess.board[position[0]][position[1]]
        chess.remove_all_pieces_except([position])
        moves = chess.generate_legal_moves(king, position, 'white')
        expected_moves = [[3, 0], [3, 1], [4, 1], [5, 0], [5, 1]]
        expect(moves).to match_array(expected_moves)
      end

      it 'allows a king to castle if conditions are met' do
        chess = Chess.new
        chess.board[4][0] = King.new('white')
        chess.board[7][0] = Rook.new('white')
        chess.board[0][0] = Rook.new('white')
        position = [4, 0] # Position of a white king
        king = chess.board[position[0]][position[1]]
        moves = chess.generate_legal_moves(king, position, 'white')
        expect(moves).to include([6, 0], [2, 0]) # King-side and Queen-side castling
      end
    end
  end
end
