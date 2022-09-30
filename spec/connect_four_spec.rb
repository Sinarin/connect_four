require_relative '../lib/connect_four'
require 'rspec'

RSpec.describe Gameboard do
  describe '#add_row' do
    subject(:board) { described_class.new }

    it 'adds 1 arrays of 7' do
      board.add_row
      expect(board.board).to eq( Array.new(1) { Array.new(7) }) 
    end

    it 'adds 6 arrays of 7' do
      6.times { board.add_row }
      expect(board.board).to eq( Array.new(6) { Array.new(7) }) 
    end

    it 'does not add an row if number of rows in 6 or more' do
      7.times { board.add_row }
      expect(board.board).not_to eq( Array.new(7) { Array.new(7) }) 
    end
  end

  describe '#place_piece' do

    context 'empty board' do
      subject(:emptyboard) { described_class.new }
      subject(:player1) { Player.new('B', emptyboard.board, "Player 1") }

      before do
        allow(emptyboard).to receive(:print_board)
      end

      it 'adds piece' do
        emptyboard.place_piece(player1, emptyboard.check_row(0), 0)
        expect(emptyboard.board[0][0]).to eq "B"
      end
    end

    context 'board with 4 rows' do
      subject(:board4)  { described_class.new(4) }
      let(:player1) { instance_double(Player, team: "B") }

      before do
        allow(board4).to receive(:print_board)
      end

      it 'adds piece to first empty column' do
        board4.place_piece(player1, board4.check_row(0), 0)
        expect(board4.board[0][0]).to eql 'B'
      end

      before do
        allow(board4).to receive(:print_board).twice
      end
      
      it 'adds piece' do
        board4.place_piece(player1, 0, 0)
        board4.place_piece(player1, 1, 0)
        expect(board4.board[0][0]).to eq "B"
        expect(board4.board[1][0]).to eq "B"
      end
    end
  end

  describe '#check_row' do
    context 'returns the first empty row for inputed column' do
      subject(:emptyboard) {described_class.new}
      it 'returns 0' do
        expect(emptyboard.check_row(0)).to be 0
      end

      it 'makes new row' do
        expect(emptyboard).to receive(:add_row)
        emptyboard.check_row(0)
      end
    end

    context 'returns first empty row when given column' do
      subject(:board3) { described_class.new(3) }
      let(:player1) { instance_double(Player, team: "R") }
      
      it 'returns row 1 (0)' do
        expect(board3.check_row(3)).to be 0
      end
      
      it 'returns row 3(2)' do
        board3.place_piece(player1, 0, 2)
        board3.place_piece(player1, 1, 2) 
        expect(board3.check_row(2)).to be 2
      end

      before do
        allow(board3).to receive(:puts)
        allow(board3).to receive(:print_board)
      end

      it 'returns nil when row is full' do
        board3.board = [
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil]
        ]
        expect(board3.check_row(0)).to be nil
      end

      it 'returns height of 4 (index of 3)' do
        board3.board = [
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil]]
        expect(board3.check_row(0)).to be 3
      end

      it 'calls add_row when row does not exist' do
        board3.board = [
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil],
          ["R", nil, nil, nil, nil, nil, nil]]
        expect(board3).to receive(:add_row)
        board3.check_row(0)
      end
    end
  end

  describe '#row_win' do
    context 'check a row for win' do
      subject(:board2) { described_class.new(2) }

      it 'returns true when 4 in a row' do
        board2.board = [['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'R', 'B', 'R', nil ]
        ]
        expect(board2.row_win(1, 2, 'R')).to be true
      end

      it 'returns false when 3 in a row' do
        board2.board = [['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'B', 'R', nil]
        ]
        expect(board2.row_win(1, 2,'R')).to be false
      end

      it 'returns false when 3 in a row on right side' do
        board2.board = [['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', nil]
        ]
        expect(board2.row_win(1, 5, 'R')).to be false
      end
    end
  end

  describe '#column_win' do
    context 'check column for a win' do
      subject(:board6) { described_class.new(6) }
      it 'returns true when 4 on a column' do
        board6.board = [
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'B', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', nil, 'R', 'R', 'R' ],
        ]
        expect(board6.column_win(4, 3, 'B')).to be true
      end

      it 'returns false when 3 on a column' do
        board6.board = [
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', nil, 'R', 'R', 'R' ],
        ['R','R', 'B', nil, 'R', 'R', 'R' ],
        ['R','R', 'R', nil, 'R', 'R', 'R' ],
        ]
        expect(board6.column_win(2, 3, 'R')).to be false
      end

      it 'returns false when 3 on a column' do
        board6.board = [
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', 'R', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ['R','R', 'B', 'B', 'R', 'R', 'R' ],
        ['R','R', 'R', 'B', 'R', 'R', 'R' ],
        ]
        expect(board6.column_win(2, 3, 'B')).to be false
      end
    end
  end

  describe '#up_diagonal_win' do
    context 'diagonal from bottom to top / <= this way' do
      subject(:board6) { described_class.new(6) }
      it '4 in a /' do
        board6.board = [
        ['R', nil, nil, nil, nil, nil, nil],
        [nil, "R", nil, nil, nil, nil, nil],
        [nil, nil, 'R', nil, nil, nil, nil],
        [nil, nil, nil, "R", nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]]
        expect(board6.up_diagonal_win(1, 1, 'R')).to be true
      end

      it '3 in a /' do
        board6.board = [
        ['R', nil, nil, nil, nil, nil, nil],
        [nil, 'R', nil, nil, nil, nil, nil],
        [nil, nil, 'R', nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, 'R']]
        expect(board6.up_diagonal_win(1, 1, 'R')).to be false
      end

      it '4 in a / off the board...' do
        board6.board = [
        ['R', nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, 'R', nil, nil, nil, nil],
        [nil, nil, nil, 'R', nil, nil, nil],
        [nil, nil, nil, nil, 'R', nil, nil],
        [nil, nil, nil, nil, nil, 'R', nil]]

        expect(board6.up_diagonal_win(3, 3, 'R')).to be true
      end

    end
  end

  describe '#down_diagonal_win' do
    context 'diagonal from bottom to top / <= this way' do
      subject(:board6) { described_class.new(6) }
      it '4 in a row' do
        board6.board = [
        [nil, nil, nil, "R", nil, nil, nil],
        [nil, nil, "R", nil, nil, nil, nil],
        [nil, "R", nil, nil, nil, nil, nil],
        ["R", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]]
        expect(board6.down_diagonal_win(0, 3, 'R')).to be true
      end

      it '3 in a row' do
        board6.board = [
        ['R', nil, nil, nil, nil, nil, "R"],
        [nil, 'R', nil, nil, nil, "R", nil],
        [nil, nil, nil, nil, "R", nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, "R", nil, nil, nil, nil, 'R']]
        expect(board6.down_diagonal_win(0, 6, 'R')).to be false
      end

      it '4 in a /' do
        board6.board = [
        ['R', nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "R", nil],
        [nil, nil, 'R', nil, "R", nil, nil],
        [nil, nil, nil, 'R', nil, nil, nil],
        [nil, nil, "R", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, 'R', nil]]
        
        expect(board6.down_diagonal_win(3, 3, 'R')).to be true
      end

    end
  end

  describe '#tie?' do
    context 'return true when board is full' do
      subject(:fullboard)  { described_class.new() }

      it 'return true when board is full' do
        fullboard.board = [
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"]
        ]
        expect(fullboard.tie).to be true
      end

      it 'returns false when array full with only 5 rows' do
        fullboard.board = [
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"]
        ]
        expect(fullboard.tie).to be false
      end
      
      it 'returns false top row is not full' do
        fullboard.board = [
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", nil]
        ]
        expect(fullboard.tie).to be false
      end
    end
  end



end


