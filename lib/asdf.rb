class Gameboard
  attr_accessor :board
  def initialize(rows = 0)
    @board = Array.new(rows) {Array.new(7)}
  end

  def start_game
    make_game
    print_board
    #
  end

  def make_game
    player1 = Player.new("R", self, "Player 1")
    player2 = Player.new("B", self, "Player 2", player1)
    player1.opponent = player2
  end
end