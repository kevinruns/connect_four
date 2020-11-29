# connect four board class
class Board
  attr_accessor :board

  def initialize(dash)
    @board = Array.new(6) { Array.new(7, dash) }
    @player_one = Player.new("\u2648", "Asterisk")
    @player_two = Player.new("\u264C", "Obelisk")
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
      space = true if @board[i][column - 1] == @dash
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

  def check_for_win(piece)
    diag_array = transform_array_diag(@board)
    board_diag = @board.each.map(&:reverse)
    diag_array_reverse = transform_array_diag(board_diag)
    check_win(piece, @board) || check_win(piece, @board.transpose) || check_win(piece, diag_array) || check_win(piece, diag_array_reverse)
  end

  def transform_array_diag(array)
    diag_array = []
    k = 0
    height = array.length
    width = array[0].length
    (0..height - 1).each do |i|
      (0..width - 1).each do |j|
        diag_array[k] ? diag_array[k].push(array[i][j]) : diag_array[k] = [array[i][j]]
        k += 1
      end
      k = k - width + 1
    end
    diag_array.filter { |diag| diag.length > 3 }
  end

  def check_win(piece, array)
    row_win = false
    height = array.length

    catch :take_me_out do
      (0..height - 1).each do |i|
        width = array[i].length
        (0..width - 4).each do |j|
          row_win = true if array[i].slice(j, 4) == ([piece] * 4)
          throw :take_me_out if row_win == true
        end
      end
    end
    row_win
  end

  def board_full
    !@board.any? { |row| row.include?(@dash) }
  end

  def play_game
    player = @player_one
    until check_for_win(player.piece) || board_full
      player = player == @player_one ? @player_two : @player_one
      show_board
      write_column(player)
    end

    str = "GAME OVER: "
    str = if check_for_win(player.piece)
            str + "#{player.name} wins"
          else
            str + "Board full"
          end

    print "\n***************************************************************************\n"
    print "  #{str}\n"
    print "***************************************************************************\n"

    show_board
  end
end
