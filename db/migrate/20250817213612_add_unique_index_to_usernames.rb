class AddUniqueIndexToUsernames < ActiveRecord::Migration[8.0]
  def up
    execute("CREATE UNIQUE INDEX index_users_on_username ON users (LOWER(username))")
  end

  def down
    execute("DROP INDEX index_users_on_username")
  end
end
