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

ActiveRecord::Schema.define(:version => 20140328195658) do

  create_table "companies", :force => true do |t|
    t.string   "stock_ticker"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "company_name"
    t.float    "current_stock_price"
    t.float    "composite_share_value"
    t.string   "slug"
    t.string   "industry"
    t.integer  "sic_code"
    t.string   "exchange"
    t.float    "current_pe_comp"
    t.float    "NAV_Valuation"
    t.float    "CAPM_Valuation"
    t.float    "WACC_Valuation"
    t.float    "Dividend_Valuation"
    t.float    "Sentiment_Valuation"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "quotes", :force => true do |t|
    t.float    "price"
    t.datetime "date"
    t.string   "stock_symbol"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "email"
  end

  create_table "stock_infos", :force => true do |t|
    t.string   "ticker_sign"
    t.string   "quandl_code"
    t.string   "proper_name"
    t.string   "industry"
    t.string   "exchange"
    t.integer  "sic_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "stocks", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "company"
    t.string   "stock_ticker"
    t.integer  "free_cash_flow"
    t.integer  "num_shares"
    t.float    "current_pe_ratio"
    t.float    "beta"
    t.string   "industry"
    t.integer  "sic_code"
    t.string   "exchange"
    t.integer  "mkt_cap"
    t.integer  "assets"
    t.integer  "debt"
    t.float    "earnings_growth"
    t.float    "forw_div_rate"
    t.float    "trail_div_rate"
    t.float    "eff_tax_rate"
  end

end
