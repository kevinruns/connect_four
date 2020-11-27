# encoding: utf-8

# connect four board class
class Board
  attr_accessor :board

  def initialize(dash)
    @board = Array.new(6) { Array.new(7, dash) }
    @player_one = Player.new("\u2648", "PlayerOne")
    @player_two = Player.new("\u264C", "PlayerTwo")
    @dash = dash
  end

  def write_column(player)
    column = 0
    until valid_column?(column)
      player.prompt_player
      column = player.select_column
    end

    @board.each_with_index do |_row, i|
      if @board[5 - i][column - 1] == @dash
        @board[5 - i][column - 1] = player.piece 
        break
      end
    end
  end

  def valid_column?(column)
    column.between?(1, 7) && column_space(column)
  end

  def column_space(column)
    space = false
    @board.each_with_index do |_row, i|
      space = true if @board[i][column - 1 ] == @dash
    end
    space
  end

  
  def show_board
    print "\n\n"
    @board.each_with_index do |_row, i|
      print '              '
      @board[i].each_with_index do |_col, j|
        print @board[i][j].center(8)
      end
      print "\n\n"
    end
    print "\n"
  end

  def play_game

    while true do
      player = player == @player_one ? @player_two : @player_one
      show_board
      write_column(player)
    end
  end

end
