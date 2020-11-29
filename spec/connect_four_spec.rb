require_relative '../lib/player'
require_relative '../lib/board'

blank = "\u26AA"
red = "\u2648"
yel = "\u264C"

player_one = Player.new("\u2648", "Asterisk")
player_two = Player.new("\u264C", "Obelisk")

describe Board do
  subject(:game_board) { Board.new(blank) }

  describe '#read_board' do
    it 'empty board' do
      empty_board = [[blank, blank, blank, blank, blank, blank, blank],
                     [blank, blank, blank, blank, blank, blank, blank],
                     [blank, blank, blank, blank, blank, blank, blank],
                     [blank, blank, blank, blank, blank, blank, blank],
                     [blank, blank, blank, blank, blank, blank, blank],
                     [blank, blank, blank, blank, blank, blank, blank]]

      expect(game_board.board).to eq(empty_board)
    end
  end

  describe '#placing pieces' do
    context 'write red to column 1' do
      before do
        allow(player_one).to receive(:prompt_player).and_return(nil)
        allow(player_one).to receive(:select_column).and_return(1)
        allow(player_two).to receive(:prompt_player).and_return(nil)
        allow(player_two).to receive(:select_column).and_return(1)
      end

      it '1 red to column 1' do
        red_in_col_1x1 = [[blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [red, blank, blank, blank, blank, blank, blank]]

        game_board.write_column(player_one)
        expect(game_board.board).to eq(red_in_col_1x1)
      end

      it '1 yellow to column 1' do
        yel_in_col_1x1 = [[blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [blank, blank, blank, blank, blank, blank, blank],
                          [yel, blank, blank, blank, blank, blank, blank]]

        game_board.write_column(player_two)
        expect(game_board.board).to eq(yel_in_col_1x1)
      end

      it 'ry to column 1' do
        ry_in_col_1x2 = [[blank, blank, blank, blank, blank, blank, blank],
                         [blank, blank, blank, blank, blank, blank, blank],
                         [blank, blank, blank, blank, blank, blank, blank],
                         [blank, blank, blank, blank, blank, blank, blank],
                         [yel, blank, blank, blank, blank, blank, blank],
                         [red, blank, blank, blank, blank, blank, blank]]

        game_board.write_column(player_one)
        game_board.write_column(player_two)
        expect(game_board.board).to eq(ry_in_col_1x2)
      end

      it 'ryryry to column 1' do
        ryryry_in_col_1x6 = [[yel, blank, blank, blank, blank, blank, blank],
                             [red, blank, blank, blank, blank, blank, blank],
                             [yel, blank, blank, blank, blank, blank, blank],
                             [red, blank, blank, blank, blank, blank, blank],
                             [yel, blank, blank, blank, blank, blank, blank],
                             [red, blank, blank, blank, blank, blank, blank]]

        3.times do
          game_board.write_column(player_one)
          game_board.write_column(player_two)
        end
        expect(game_board.board).to eq(ryryry_in_col_1x6)
      end

      it '8 reds to column 1: 6 max, 4 reds column 2' do
        red_in_col_1x6_2x4 = [[red, blank, blank, blank, blank, blank, blank],
                              [red, blank, blank, blank, blank, blank, blank],
                              [red, red, blank, blank, blank, blank, blank],
                              [red, red, blank, blank, blank, blank, blank],
                              [red, red, blank, blank, blank, blank, blank],
                              [red, red, blank, blank, blank, blank, blank]]

        allow(player_one).to receive(:select_column).and_return(1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2)
        10.times { game_board.write_column(player_one) }

        expect(game_board.board).to eq(red_in_col_1x6_2x4)
      end

      it 'write red and yel to every column' do
        red_in_all_cols = [[blank, blank, blank, blank, yel, red, blank],
                           [blank, yel, blank, blank, red, red, blank],
                           [blank, red, yel, yel, red, red, blank],
                           [yel, red, red, red, red, red, yel],
                           [red, red, red, red, red, red, red],
                           [red, red, red, red, red, red, red]]

        allow(player_one).to receive(:select_column).and_return(1, 2, 3, 4, 5, 6, 7,
                                                                1, 2, 3, 4, 5, 6, 7,
                                                                   2, 3, 4, 5, 6,
                                                                   2,       5, 6,
                                                                            5, 6,
                                                                               6)
        25.times { game_board.write_column(player_one) }

        allow(player_two).to receive(:select_column).and_return(1, 2, 3, 4, 5, 6, 7)
        6.times { game_board.write_column(player_two) }
        expect(game_board.board).to eq(red_in_all_cols)
      end
    end
  end


  describe '#valid_column' do

    before do
      allow(player_one).to receive(:prompt_player).and_return(nil)
      allow(player_two).to receive(:prompt_player).and_return(nil)
    end

    context 'send wrong numbers' do
      it 'number too high' do
        result = game_board.valid_column?(10)
        expect(result).to eq(false)
      end
      it 'number too low' do
        result = game_board.valid_column?(0)
        expect(result).to eq(false)
      end
    end

    context 'send right numbers' do
      it 'number 1' do
        result = game_board.valid_column?(1)
        expect(result).to eq(true)
      end
      it 'number 7' do
        result = game_board.valid_column?(7)
        expect(result).to eq(true)
      end
      it 'number 3' do
        result = game_board.valid_column?(3)
        expect(result).to eq(true)
      end
    end

    context 'column full' do
      it 'one space left' do
        allow(player_one).to receive(:select_column).and_return(1)
        5.times { game_board.write_column(player_one) }
        result = game_board.valid_column?(1)
        expect(result).to eq(true)
      end
      it 'column full' do
        allow(player_one).to receive(:select_column).and_return(1)
        6.times { game_board.write_column(player_one) }
        result = game_board.valid_column?(1)
        expect(result).to eq(false)
      end
    end
  end

  describe '#check_win' do

    before do
      allow(player_one).to receive(:prompt_player).and_return(nil)
      allow(player_two).to receive(:prompt_player).and_return(nil)
    end

    context 'blank board returns false' do
      it 'return false player one' do
        win = game_board.check_for_win(player_one.piece)
        expect(win).to eq(false)
      end
      it 'return false player two' do
        win = game_board.check_for_win(player_two.piece)
        expect(win).to eq(false)
      end
    end

    context 'three in row returns false' do
      it 'return false' do
        allow(player_one).to receive(:select_column).and_return(1,2,3)
        3.times { game_board.write_column(player_one) }
        win = game_board.check_for_win(player_one.piece)
        expect(win).to eq(false)
      end
    end

    context 'four red in row returns true' do
      it 'return true' do
        allow(player_one).to receive(:select_column).and_return(1, 2, 3, 4)
        4.times { game_board.write_column(player_one) }
        win = game_board.check_for_win(player_one.piece)
        expect(win).to eq(true)
      end
    end

    context 'four yellow in column returns true' do
      it 'return true' do
        allow(player_two).to receive(:select_column).and_return(2)
        4.times { game_board.write_column(player_two) }
        win = game_board.check_for_win(player_two.piece)
        expect(win).to eq(true)
      end
    end

    context 'two red and two yellow in row returns false' do
      it 'return false' do
        allow(player_one).to receive(:select_column).and_return(1, 2)
        2.times { game_board.write_column(player_one) }
        allow(player_two).to receive(:select_column).and_return(3, 4)
        2.times { game_board.write_column(player_two) }
        win = game_board.check_for_win(player_one.piece) || 
              game_board.check_for_win(player_two.piece)
        expect(win).to eq(false)
      end
    end

    context 'four yellow diagonal - up slope' do
      it 'return true' do
        allow(player_one).to receive(:select_column).and_return(1)
        3.times { game_board.write_column(player_one) }
        allow(player_one).to receive(:select_column).and_return(2)
        2.times { game_board.write_column(player_one) }
        allow(player_one).to receive(:select_column).and_return(3)
        1.times { game_board.write_column(player_one) }

        allow(player_two).to receive(:select_column).and_return(1, 2, 3, 4)
        4.times { game_board.write_column(player_two) }
        win = game_board.check_for_win(player_two.piece)
        expect(win).to eq(true)
      end  
    end

    context 'four red diagonal - down slope' do
      it 'return true' do
        allow(player_two).to receive(:select_column).and_return(4)
        3.times { game_board.write_column(player_two) }
        allow(player_two).to receive(:select_column).and_return(3)
        2.times { game_board.write_column(player_two) }
        allow(player_two).to receive(:select_column).and_return(2)
        1.times { game_board.write_column(player_two) }

        allow(player_one).to receive(:select_column).and_return(1, 2, 3, 4)
        4.times { game_board.write_column(player_one) }
        win = game_board.check_for_win(player_one.piece)
        expect(win).to eq(true)
      end  
    end
  end

end
