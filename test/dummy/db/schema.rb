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

ActiveRecord::Schema.define(version: 2020_05_13_142211) do

  create_table "payments", force: :cascade do |t|
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "wx_payments", force: :cascade do |t|
    t.integer "payment_id"
    t.string "appid"
    t.string "mch_id"
    t.string "device_info"
    t.string "openid"
    t.string "is_subscribe"
    t.string "trade_type"
    t.string "bank_type"
    t.integer "total_fee"
    t.integer "settlement_total_fee"
    t.string "fee_type"
    t.integer "cash_fee"
    t.string "cash_fee_type"
    t.string "transaction_id"
    t.string "out_trade_no"
    t.string "attach"
    t.date "time_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["out_trade_no"], name: "index_wx_payments_on_out_trade_no"
    t.index ["payment_id"], name: "index_wx_payments_on_payment_id"
  end

end
