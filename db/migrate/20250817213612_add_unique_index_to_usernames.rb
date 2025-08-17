class AddUniqueIndexToUsernames < ActiveRecord::Migration[8.0]
  def change
    execute("CREATE UNIQUE INDEX index_users_on_username ON users (LOWER(username))")
  end
end
