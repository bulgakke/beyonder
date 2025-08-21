class AddStatusToTicTacToeGames < ActiveRecord::Migration[8.0]
  def change
    create_enum :tic_tac_toe_game_status, [:pending, :ongoing, :finished]

    add_column :tic_tac_toe_games, :status, :enum,
      enum_type: :tic_tac_toe_game_status, null: false, default: :pending
  end
end
