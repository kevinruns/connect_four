# connect four player class
class Player
  attr_reader :piece

  def initialize(code, player_name)
    @piece = code
    @name = player_name
  end

  def select_column
    gets.chomp.to_i
  end

  def prompt_player
    print "Enter column 1-7 : "
  end
end
