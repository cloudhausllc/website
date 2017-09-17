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

ActiveRecord::Schema.define(version: 20170917221703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "charges", force: :cascade do |t|
    t.text     "stripe_id"
    t.text     "customer_id"
    t.text     "source_id"
    t.text     "invoice_id"
    t.integer  "amount"
    t.integer  "amount_refunded"
    t.integer  "created"
    t.text     "description"
    t.string   "dispute"
    t.string   "failure_code"
    t.string   "failure_message"
    t.json     "outcome"
    t.text     "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "charges", ["customer_id"], name: "index_charges_on_customer_id", using: :btree
  add_index "charges", ["invoice_id"], name: "index_charges_on_invoice_id", using: :btree
  add_index "charges", ["source_id"], name: "index_charges_on_source_id", using: :btree
  add_index "charges", ["stripe_id"], name: "index_charges_on_stripe_id", using: :btree

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

  create_table "invoices", force: :cascade do |t|
    t.text     "stripe_id"
    t.text     "subscription_id"
    t.text     "charge_id"
    t.text     "customer_id"
    t.integer  "amount_due"
    t.integer  "attempt_count"
    t.boolean  "attempted"
    t.boolean  "closed"
    t.integer  "date"
    t.text     "description"
    t.boolean  "livemode"
    t.integer  "next_payment_attempt"
    t.integer  "period_start"
    t.integer  "period_end"
    t.integer  "subtotal"
    t.integer  "tax"
    t.integer  "tax_percent"
    t.integer  "total"
    t.boolean  "payment_succeeded"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "invoices", ["charge_id"], name: "index_invoices_on_charge_id", using: :btree
  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  add_index "invoices", ["stripe_id"], name: "index_invoices_on_stripe_id", using: :btree
  add_index "invoices", ["subscription_id"], name: "index_invoices_on_subscription_id", using: :btree

  create_table "news_articles", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.text     "subject"
    t.text     "body"
    t.boolean  "published",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "brand"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.text     "last4"
    t.text     "stripe_token_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "stripe_card_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.text     "type"
    t.text     "stripe_token"
    t.text     "notes"
    t.text     "status"
    t.json     "outcome"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "plans", force: :cascade do |t|
    t.text     "stripe_plan_id"
    t.boolean  "active",                        default: true, null: false
    t.text     "stripe_plan_name"
    t.integer  "stripe_plan_amount"
    t.text     "stripe_plan_interval"
    t.integer  "stripe_plan_trial_period_days"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "admin_selectable_only",         default: true, null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "password_digest"
    t.boolean  "active",                 default: true,  null: false
    t.boolean  "admin",                  default: false, null: false
    t.integer  "membership_level_id"
    t.text     "stripe_customer_id"
    t.integer  "plan_id"
    t.text     "stripe_subscription_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "web_hook_stripe_events", force: :cascade do |t|
    t.boolean  "livemode",    null: false
    t.text     "event_type",  null: false
    t.text     "stripe_id",   null: false
    t.text     "object",      null: false
    t.text     "request"
    t.datetime "api_version"
    t.json     "data",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "processing"
    t.datetime "processed"
  end

  add_index "web_hook_stripe_events", ["stripe_id"], name: "index_web_hook_stripe_events_on_stripe_id", unique: true, using: :btree

end
