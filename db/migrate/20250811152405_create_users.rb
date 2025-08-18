class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :password_digest, null: false
      t.string :username, null: false

      t.timestamps
    end

    execute <<~SQL
      CREATE UNIQUE INDEX index_users_on_email_address
        ON users (LOWER(email_address))
        WHERE (email_address IS NOT NULL)
    SQL
  end
end
