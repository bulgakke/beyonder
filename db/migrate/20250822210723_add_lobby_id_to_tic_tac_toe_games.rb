class AddLobbyIdToTicTacToeGames < ActiveRecord::Migration[8.0]
  def change
    add_reference :tic_tac_toe_games, :lobby, null: false, foreign_key: { to_table: :tic_tac_toe_lobbies }
  end
end
