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

ActiveRecord::Schema.define(version: 0) do

  create_table "COURSE", primary_key: "course_code", force: :cascade do |t|
    t.string "credits",       limit: 3,    null: false
    t.string "prerequisites", limit: 45
    t.string "corequisites",  limit: 45
    t.string "name",          limit: 100,  null: false
    t.string "description",   limit: 1000, null: false
  end

  create_table "DRAFTS", force: :cascade do |t|
    t.string "username", limit: 100, null: false
    t.string "schedule", limit: 100, null: false
  end

  add_index "DRAFTS", ["username"], name: "username_idx", using: :btree

  create_table "MAJOR", force: :cascade do |t|
    t.string "name",         limit: 45,  null: false
    t.string "abbr",         limit: 5,   null: false
    t.string "credits",      limit: 3,   null: false
    t.string "requirements", limit: 500
  end

  create_table "USER", primary_key: "user_id", force: :cascade do |t|
    t.string  "username",     limit: 45,  null: false
    t.string  "password",     limit: 45,  null: false
    t.string  "first_name",   limit: 45,  null: false
    t.string  "last_name",    limit: 45,  null: false
    t.string  "course_taken", limit: 500
    t.integer "major_1",      limit: 4,   null: false
    t.integer "major_2",      limit: 4
  end

  add_index "USER", ["major_1", "major_2"], name: "major_1_idx", using: :btree
  add_index "USER", ["major_2"], name: "major_2", using: :btree
  add_index "USER", ["username"], name: "username_UNIQUE", unique: true, using: :btree

  add_foreign_key "DRAFTS", "USER", column: "username", primary_key: "username", name: "username"
  add_foreign_key "USER", "MAJOR", column: "major_1", name: "major_1"
  add_foreign_key "USER", "MAJOR", column: "major_2", name: "major_2"
end
