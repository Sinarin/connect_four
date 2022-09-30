class Player 
  attr_accessor :opponent, :name, :team
  def initialize(team, name, opponent = nil)
    @name = name
    @team = team
    @opponent = opponent
  end
end