class MakeTicTacToeGamePlayersOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tic_tac_toe_games, :x_player_id, true
    change_column_null :tic_tac_toe_games, :o_player_id, true
  end
end
