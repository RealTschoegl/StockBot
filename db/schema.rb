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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131014214837) do

  create_table "companies", :force => true do |t|
    t.string   "stock_ticker"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "company_name"
    t.float    "current_stock_price"
    t.integer  "free_cash_flow"
    t.integer  "num_shares"
    t.float    "PE_ratio"
    t.float    "beta"
    t.float    "cost_of_equity"
    t.float    "fcf_share_value"
    t.float    "capm_share_value"
    t.float    "composite_share_value"
    t.boolean  "complete"
    t.string   "slug"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "stocks", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "company"
    t.string   "stock_ticker"
    t.float    "current_stock_price"
    t.integer  "free_cash_flow"
    t.integer  "num_shares"
    t.float    "PE_ratio"
    t.float    "beta"
    t.float    "cost_of_equity"
    t.float    "fcf_share_value"
    t.float    "capm_share_value"
    t.float    "composite_share_value"
    t.boolean  "complete"
  end

end
