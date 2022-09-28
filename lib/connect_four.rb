class Gameboard
  attr_accessor :board
  def initialize(rows = 0)
    @board = Array.new(rows) {Array.new(7)}
  end

  def add_row 
    @board << Array.new(7) unless @board.length >= 6
  end

  def place_piece(team, column)
    begin
      @board[check_row(column)][column] = team
    rescue
      puts 'invalid input try again'
      print_board()
    end
  end

  def check_row(column)
    #for each existing row startin from first
    #check if the column in that row is open else go to next
    @board.each_with_index do |row, idx| 
      if row.fetch(column) == nil
        return idx
      end
    end
    #if none of the exsit rows are open in that column add a row and return the index
    #of that row number
    if @board.length < 7
      add_row
      return (@board.length - 1)
    end
  end

  def print_board
    blank = 6 - @board.length
    for i in 1..blank
      print "|"
      for i in 1..7
        print " |"
      end
      print "\n"
    end
    
    @board.each do |row|
      print "|"
      row.each do |element|
        if element
          print "#{element}|"
        else
          print " |"
        end
      end
      print "\n"
    end
  end 

end

class Player 
  def initialize(team, board)
    @team = team
    @board = board
  end

  def place_piece(column)
    @board.place_piece(@team, column)
  end
end


board = Gameboard.new
board.place_piece("R", 0)
p board.board
board.print_board
