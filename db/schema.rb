# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_21_220116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "tic_tac_toe_game_status", ["pending", "ongoing", "finished"]
  create_enum "tic_tac_toe_symbol", ["x", "o"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.bigint "author_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["resource_type", "resource_id"], name: "index_posts_on_resource"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "last_login_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tic_tac_toe_games", force: :cascade do |t|
    t.bigint "x_player_id", null: false
    t.bigint "o_player_id", null: false
    t.jsonb "board", default: [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "status", default: "pending", null: false, enum_type: "tic_tac_toe_game_status"
    t.index ["o_player_id"], name: "index_tic_tac_toe_games_on_o_player_id"
    t.index ["x_player_id"], name: "index_tic_tac_toe_games_on_x_player_id"
  end

  create_table "tic_tac_toe_moves", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "game_id", null: false
    t.integer "row", null: false
    t.integer "column", null: false
    t.enum "symbol", null: false, enum_type: "tic_tac_toe_symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_tic_tac_toe_moves_on_game_id"
    t.index ["player_id"], name: "index_tic_tac_toe_moves_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address"
    t.string "password_digest", null: false
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email_address)::text)", name: "index_users_on_email_address", unique: true, where: "(email_address IS NOT NULL)"
    t.index "lower((username)::text)", name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "tic_tac_toe_games", "users", column: "o_player_id"
  add_foreign_key "tic_tac_toe_games", "users", column: "x_player_id"
  add_foreign_key "tic_tac_toe_moves", "tic_tac_toe_games", column: "game_id"
  add_foreign_key "tic_tac_toe_moves", "users", column: "player_id"
end
