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

ActiveRecord::Schema.define(version: 20160110080833) do

  create_table "doc_categories", force: :cascade do |t|
    t.string   "name_jp",              limit: 255
    t.string   "name_en",              limit: 255
    t.integer  "appear_count",         limit: 4
    t.integer  "doc_category_type_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "doc_category_infos", force: :cascade do |t|
    t.integer  "doc_category_id", limit: 4
    t.integer  "word_id",         limit: 4
    t.integer  "appear_count",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "doc_category_types", force: :cascade do |t|
    t.string   "name_jp",    limit: 255
    t.string   "name_en",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "salieris", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "words", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "value",            limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "category_type_id", limit: 4
  end

end
