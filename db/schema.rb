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

  create_table "dlcs", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "steamid",         limit: 4
    t.integer  "game_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "metascore",       limit: 4
    t.text     "metaurl",         limit: 65535
    t.text     "hltb",            limit: 65535
    t.float    "MainStory",       limit: 53
    t.float    "MainExtra",       limit: 53
    t.float    "Completion",      limit: 53
    t.float    "Combined",        limit: 53
    t.text     "description",     limit: 65535
    t.text     "website",         limit: 65535
    t.text     "review",          limit: 65535
    t.text     "minreq",          limit: 65535
    t.text     "recreq",          limit: 65535
    t.text     "releasedate",     limit: 65535
    t.text     "developer",       limit: 65535
    t.text     "headerimg",       limit: 65535
    t.integer  "recommendations", limit: 4
    t.text     "legal",           limit: 65535
    t.string   "itad",            limit: 255
  end

  add_index "dlcs", ["game_id"], name: "index_dlcs_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "steamid",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "metascore",       limit: 4
    t.text     "metaurl",         limit: 65535
    t.text     "hltb",            limit: 65535
    t.float    "MainStory",       limit: 53
    t.float    "MainExtra",       limit: 53
    t.float    "Completion",      limit: 53
    t.float    "Combined",        limit: 53
    t.text     "description",     limit: 65535
    t.text     "website",         limit: 65535
    t.text     "review",          limit: 65535
    t.text     "minreq",          limit: 65535
    t.text     "recreq",          limit: 65535
    t.text     "releasedate",     limit: 65535
    t.text     "developer",       limit: 65535
    t.text     "headerimg",       limit: 65535
    t.integer  "recommendations", limit: 4
    t.text     "legal",           limit: 65535
    t.text     "subreddit",       limit: 65535
    t.text     "wikipedia",       limit: 65535
    t.integer  "steampercent",    limit: 4
    t.string   "itad",            limit: 255
  end

  create_table "packages", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "game_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "releasedate", limit: 65535
    t.text     "headerimg",   limit: 65535
    t.integer  "packageid",   limit: 4
    t.text     "apps",        limit: 65535
    t.string   "itad",        limit: 255
  end

  add_index "packages", ["game_id"], name: "index_packages_on_game_id", using: :btree

end
