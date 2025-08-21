class CreateTicTacToeMoves < ActiveRecord::Migration[8.0]
  def change
    create_enum :tic_tac_toe_symbol, [:x, :o]

    create_table :tic_tac_toe_moves do |t|
      t.references :player, null: false, foreign_key: { to_table: :users }
      t.references :game, null: false, foreign_key: { to_table: :tic_tac_toe_games }
      t.integer :row, null: false
      t.integer :column, null: false
      t.enum :symbol, enum_type: :tic_tac_toe_symbol, null: false

      t.timestamps
    end
  end
end
