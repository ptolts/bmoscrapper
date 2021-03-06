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

ActiveRecord::Schema.define(version: 20160803210848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "holdings", force: :cascade do |t|
    t.integer  "note_id"
    t.date     "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holdings_stocks", id: false, force: :cascade do |t|
    t.integer "holding_id", null: false
    t.integer "stock_id",   null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "name"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "note_id"
    t.text     "full_name"
  end

  create_table "stocks", force: :cascade do |t|
    t.text     "name"
    t.text     "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "values", force: :cascade do |t|
    t.decimal  "price"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "note_id"
    t.integer  "stock_id"
  end

  add_index "values", ["note_id"], name: "index_values_on_note_id", using: :btree
  add_index "values", ["stock_id"], name: "index_values_on_stock_id", using: :btree

end
