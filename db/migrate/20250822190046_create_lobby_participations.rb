class CreateLobbyParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :lobby_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lobby, polymorphic: true, null: false
      t.boolean :ready, null: false, default: false

      t.timestamps
    end

    add_index :lobby_participations, [:user_id, :lobby_id, :lobby_type], unique: true
  end
end
