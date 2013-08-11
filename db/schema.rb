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

ActiveRecord::Schema.define(:version => 20130703174744) do

  create_table "stocks", :force => true do |t|
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "company"
    t.string   "stock_ticker"
    t.integer  "free_cash_flow"
    t.integer  "num_shares"
    t.float    "PE_ratio"
    t.float    "dividend_per_share"
    t.float    "dividend_growth_rate"
    t.float    "beta"
    t.float    "cost_of_equity"
    t.float    "current_stock_price"
    t.float    "expected_share_value"
    t.float    "capm_share_value"
    t.float    "dividend_share_value"
    t.float    "composite_share_value"
  end

end
