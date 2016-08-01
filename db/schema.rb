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

ActiveRecord::Schema.define(version: 20160801012623) do

  create_table "asset_tools", force: :cascade do |t|
    t.boolean  "active",       default: false, null: false
    t.boolean  "on_premises",  default: false, null: false
    t.integer  "value"
    t.text     "name"
    t.integer  "user_id",                      null: false
    t.integer  "quantity",     default: 1,     null: false
    t.text     "url"
    t.integer  "sqft"
    t.text     "model_number"
    t.text     "notes"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "index_images", force: :cascade do |t|
    t.boolean  "active",             default: false, null: false
    t.integer  "user_id",                            null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "caption"
    t.text     "url"
  end

  create_table "news_articles", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.text     "subject"
    t.text     "body"
    t.boolean  "published",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "password_digest"
    t.boolean  "active",          default: false, null: false
    t.boolean  "admin",           default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
