# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150624180051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dlcs", force: :cascade do |t|
    t.string   "name"
    t.integer  "steamid"
    t.integer  "game_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "metascore"
    t.text     "metaurl"
    t.text     "hltb"
    t.float    "MainStory"
    t.float    "MainExtra"
    t.float    "Completion"
    t.float    "Combined"
    t.text     "description"
    t.text     "website"
    t.text     "review"
    t.text     "minreq"
    t.text     "recreq"
    t.text     "releasedate"
    t.text     "developer"
    t.text     "headerimg"
    t.integer  "recommendations"
    t.text     "legal"
    t.string   "itad"
  end

  add_index "dlcs", ["game_id"], name: "index_dlcs_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "steamid"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "metascore"
    t.text     "metaurl"
    t.text     "hltb"
    t.float    "MainStory"
    t.float    "MainExtra"
    t.float    "Completion"
    t.float    "Combined"
    t.text     "description"
    t.text     "website"
    t.text     "review"
    t.text     "minreq"
    t.text     "recreq"
    t.text     "releasedate"
    t.text     "developer"
    t.text     "headerimg"
    t.integer  "recommendations"
    t.text     "legal"
    t.text     "subreddit"
    t.text     "wikipedia"
    t.integer  "steampercent"
    t.string   "itad"
  end

  create_table "packages", force: :cascade do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "releasedate"
    t.text     "headerimg"
    t.integer  "packageid"
    t.text     "apps"
    t.string   "itad"
  end

  add_index "packages", ["game_id"], name: "index_packages_on_game_id", using: :btree

  add_foreign_key "dlcs", "games"
  add_foreign_key "packages", "games"
end
