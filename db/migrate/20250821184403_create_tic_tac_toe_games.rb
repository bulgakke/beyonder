class CreateTicTacToeGames < ActiveRecord::Migration[8.0]
  def change
    create_table :tic_tac_toe_games do |t|
      t.references :x_player, null: false, foreign_key: { to_table: :users }
      t.references :o_player, null: false, foreign_key: { to_table: :users }
      t.jsonb :board, null: false, default: [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]

      t.timestamps
    end
  end
end
