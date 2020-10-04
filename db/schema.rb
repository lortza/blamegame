# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_29_002205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "code"
    t.boolean "players_ready", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_rounds"
    t.boolean "adult_content_permitted", default: false
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.boolean "adult_rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "deck_id"
    t.boolean "archived", default: false
    t.index ["deck_id"], name: "index_questions_on_deck_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "question_id", null: false
    t.integer "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["question_id"], name: "index_rounds_on_question_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "candidate_id"
    t.bigint "voter_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["candidate_id"], name: "index_submissions_on_candidate_id"
    t.index ["round_id"], name: "index_submissions_on_round_id"
    t.index ["voter_id"], name: "index_submissions_on_voter_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.boolean "admin", default: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "decks", "users"
  add_foreign_key "games", "users"
  add_foreign_key "players", "games"
  add_foreign_key "questions", "decks"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "questions"
  add_foreign_key "submissions", "players", column: "candidate_id"
  add_foreign_key "submissions", "players", column: "voter_id"
  add_foreign_key "submissions", "rounds"
end
