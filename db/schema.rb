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

ActiveRecord::Schema.define(version: 2019_06_17_065502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_words", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "word_id"
    t.index ["game_id"], name: "index_game_words_on_game_id"
    t.index ["word_id"], name: "index_game_words_on_word_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "board", array: true
    t.integer "duration", default: 0, null: false
    t.string "token"
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_games_on_token", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string "value", null: false
    t.index ["value"], name: "index_words_on_value", unique: true
  end

end
