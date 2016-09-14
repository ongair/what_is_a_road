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

ActiveRecord::Schema.define(version: 20160914120447) do

  create_table "photos", force: :cascade do |t|
    t.string   "file_url"
    t.integer  "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "photos", ["report_id"], name: "index_photos_on_report_id"

  create_table "progresses", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "progresses", ["report_id"], name: "index_progresses_on_report_id"
  add_index "progresses", ["step_id"], name: "index_progresses_on_step_id"

  create_table "reports", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "road_id"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "complete",   default: false
    t.string   "address"
  end

  add_index "reports", ["road_id"], name: "index_reports_on_road_id"
  add_index "reports", ["user_id"], name: "index_reports_on_user_id"

  create_table "roads", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "steps", force: :cascade do |t|
    t.string   "name"
    t.string   "step_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "prompt_text"
    t.integer  "next_step_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "external_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
