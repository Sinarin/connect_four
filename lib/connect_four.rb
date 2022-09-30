class Gameboard
  attr_accessor :board
  def initialize(rows = 0)
    @board = Array.new(rows) {Array.new(7)}
    @last_piece = {row: nil, column: nil, player: nil}
  end

  def add_row 
    @board << Array.new(7) unless @board.length >= 6
  end

  def place_piece(player, row, column)
    @board[row][column] = player.team
    print_board
    @last_piece[:row] = row
    @last_piece[:column] = column
    @last_piece[:player] = player
  end

  def tie
    @board.length == 6 && @board[5].all? { |element| element != nil}
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

  def check_win()
    if column_win(@last_piece[:row], @last_piece[:column], @last_piece[:player].team) || row_win(@last_piece[:row], @last_piece[:column], @last_piece[:player].team)||
       up_diagonal_win(@last_piece[:row], @last_piece[:column], @last_piece[:player].team) || down_diagonal_win(@last_piece[:row], @last_piece[:column], @last_piece[:player].team)
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
    #makes players and get row and column and then loops turn till end game
    player1 = Player.new("R", "Player 1")
    player2 = Player.new("B", "Player 2", player1)
    player1.opponent = player2
    print_board

    while 
      turn(player1)
      break if check_win || tie
      turn(player2)
      break if check_win|| tie
    end

    if check_win
      you_win()
    elsif tie()
      tiegame()
    end
  end

  def turn(player)
  #when check row is nil repeat
    column = ask_column(player)
    while check_row(column) == nil
      column = ask_column(player)
    end
    row = check_row(column)
    place_piece(player, row, column)
  end

  def you_win()
    puts "#{@last_piece[:player].name} Wins! (team:#{@last_piece[:player].team})"
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
  def initialize(team, name, opponent = nil)
    @name = name
    @team = team
    @opponent = opponent
  end
end


board = Gameboard.new
board.start_game

