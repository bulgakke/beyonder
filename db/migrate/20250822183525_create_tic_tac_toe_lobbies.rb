class CreateTicTacToeLobbies < ActiveRecord::Migration[8.0]
  def change
    create_table :tic_tac_toe_lobbies do |t|
      t.text :title

      t.timestamps
    end
  end
end
