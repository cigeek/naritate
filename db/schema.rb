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

ActiveRecord::Schema.define(version: 20140211134305) do

  create_table "foreigntitles", force: true do |t|
    t.string   "title",                  null: false
    t.string   "asin",                   null: false
    t.integer  "favs",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boos",       default: 0
  end

  add_index "foreigntitles", ["asin"], name: "index_foreigntitles_on_asin", unique: true
  add_index "foreigntitles", ["title"], name: "index_foreigntitles_on_title", unique: true

  create_table "japanesetitles", force: true do |t|
    t.string   "title"
    t.string   "asin"
    t.integer  "favs",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boos",       default: 0
  end

  add_index "japanesetitles", ["asin"], name: "index_japanesetitles_on_asin", unique: true
  add_index "japanesetitles", ["title"], name: "index_japanesetitles_on_title", unique: true

end
