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
      before do
        allow(emptyboard).to receive(:check_row)
      end

      it 'calls check_row' do
        expect(emptyboard).to receive(:check_row)
        emptyboard.place_piece('R', 0)
      end

      before do
        allow(emptyboard).to receive(:check_row)
      end

      it 'adds piece' do
        board = Gameboard.new
        board.place_piece('R', 0)
        expect(board.board[0][0]).to eq "R"
        #doesnt work with:
        #emptyboard.place_piece('R', 0)
        #expect(emptyboard.board[0][0]).to eq "R"
      end
    end

    context 'board with 4 rows' do
      subject(:board4)  { described_class.new(4) }
      it 'adds piece to first empty column' do
        board4.place_piece('R', 0)
        expect(board4.board[0][0]).to eql 'R'
      end
      
      it 'adds piece' do
        board = Gameboard.new(4)
        board.place_piece('R', 0)
        board.place_piece('R', 0)
        expect(board.board[0][0]).to eq "R"
        expect(board.board[1][0]).to eq "R"
      end

    end
    
  end
end


