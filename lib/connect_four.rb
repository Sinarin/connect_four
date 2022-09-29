class Gameboard
  attr_accessor :board
  def initialize(rows = 0)
    @board = Array.new(rows) {Array.new(7)}
  end

  def add_row 
    @board << Array.new(7) unless @board.length >= 6
  end

  def place_piece(player, column)
    begin
      row = check_row(column)
      @board[row][column] = player.team
      print_board
    rescue
      puts 'invalid input try again'
      print_board()
      place_piece(player, ask_column(player))
    end
    if check_win(row, column, player.team)
      you_win(player)
    elsif tie?()
      tiegame()
    else
      place_piece(player.opponent, ask_column(player.opponent))
    end
  end

  def tie?
    if @board.length == 7
      if @board[6].all? { |element| element != nil}
        true
      else
        false
      end
    else
      false
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
    if @board.length < 6
      add_row
      return (@board.length - 1)
    else
      nil
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
    
    @board.reverse.each do |row|
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

  def check_win(row, column, team)
    if column_win(row, column, team) || row_win(row, column, team)||
       up_diagonal_win(row, column, team) || down_diagonal_win(row, column, team)
      return true
    end 
  end

  def row_win(row, column, team)
    right_column = column
    left_column = column
    count = 1
    while team == @board[row][right_column + 1]
      count += 1
      right_column += 1
    end

    while team == @board[row][left_column - 1] && left_column > 0
      count += 1
      left_column -= 1
    end
    count > 3 ? true : false
  end

  def column_win(row, column, team)
    count = 1
    row_below = row
    while team == @board[row_below - 1][column] && row_below > 0
      count += 1
      row_below -= 1
    end
    count > 3 ? true : false
  end

  def up_diagonal_win(row, column, team)
    new_row = row + 1
    new_column = column + 1
    count = 1
    while new_column <= 6 && new_row <= 5 && new_row < @board.length && team == @board[new_row][new_column]
      count += 1
      new_column += 1
      new_row += 1
    end

    new_row = row - 1
    new_column = column - 1
    while new_column >= 0 && new_row >= 0 && new_row < @board.length && team == @board[new_row][new_column]
      count += 1
      new_column -= 1
      new_row -= 1
    end
    count > 3 ? true : false
  end

  def down_diagonal_win(row, column, team)
    new_row = row - 1
    new_column = column + 1
    count = 1
    while new_column <= 6 && new_row >= 0 && new_row < @board.length && team == @board[new_row][new_column] 
      count += 1
      new_column += 1
      new_row -= 1
    end

    new_row = row + 1
    new_column = column - 1
    while new_column >= 0 && new_row <= 5 && new_row < @board.length && team == @board[new_row][new_column]
      count += 1
      new_column -= 1
      new_row += 1
    end
    count > 3 ? true : false
  end

  def start_game
    player1 = Player.new("R", self, "Player 1")
    player2 = Player.new("B", self, "Player 2", player1)
    player1.opponent = player2
    print_board
    place_piece(player1, ask_column(player1))
  end

  def you_win(player)
    puts "#{player.name} Wins"
    replay()
  end

  def tiegame
    puts "Tie game."
    replay()
  end

  def replay
    puts "Would you like to play again? (y/n)" 
    anwser = gets.chomp.downcase
    if anwser == "y" || anwser == "yes"
      @board = []
      start_game()
    else
      exit
    end
  end

  def ask_column(player)
    puts "#{player.name} which column would you like to insert your piece? (1 - 7)"
    begin
      column = gets.chomp.to_i - 1
      if column.between?(0, 6)
        return column
      else
        puts "invalid input please try again"
        ask_column(player)
      end
    rescue
      puts "invalid input please try again"
      ask_column(player)
    end
  end


end

class Player 
  attr_accessor :opponent, :name, :team
  def initialize(team, board, name, opponent = nil)
    @name = name
    @team = team
    @board = board
    @opponent = opponent
  end

  def place_piece
    @board.place_piece(@team, ask_column())
    @opponent.place_piece
  end

  def ask_column
    puts "#{@name} which column would you like to insert your piece? (1 - 7)"
    begin
      column = gets.chomp.to_i
      if column.between?(0, 6)
        return column
      else
        puts "invalid input please try again"
        ask_column
      end
    rescue
      puts "invalid input please try again"
      ask_column
    end
  end
end

=begin
board = Gameboard.new
board.start_game
=end
