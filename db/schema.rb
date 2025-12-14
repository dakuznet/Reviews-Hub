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

ActiveRecord::Schema[8.1].define(version: 2025_12_14_164308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "movies", force: :cascade do |t|
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "director"
    t.integer "duration"
    t.string "genre"
    t.string "producer"
    t.string "screenwriter"
    t.string "studio"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["user_id"], name: "index_movies_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "rating", null: false
    t.bigint "reviewable_id", null: false
    t.string "reviewable_type", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
    t.index ["user_id", "reviewable_type", "reviewable_id"], name: "idx_user_reviewable", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "movies", "users"
  add_foreign_key "reviews", "users"
end
