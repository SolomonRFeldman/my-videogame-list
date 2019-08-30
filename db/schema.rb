# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_30_200721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.string "post_content"
    t.float "rating"
    t.boolean "current_rating"
    t.boolean "played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "game_id", "current_rating"], name: "index_activities_on_user_id_and_game_id_and_current_rating", unique: true, where: "(current_rating IS TRUE)"
    t.index ["user_id", "game_id", "played"], name: "index_activities_on_user_id_and_game_id_and_played", unique: true, where: "(played IS TRUE)"
  end

  create_table "games", force: :cascade do |t|
    t.citext "name"
    t.index ["name"], name: "index_games_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.citext "username"
    t.citext "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
