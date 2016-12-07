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

ActiveRecord::Schema.define(version: 20150218012901) do

  create_table "announcements", force: true do |t|
    t.string   "content"
    t.boolean  "active",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deluxe_packages", force: true do |t|
    t.text    "description"
    t.string  "value"
    t.float   "price"
    t.integer "training_class_id"
  end

  add_index "deluxe_packages", ["training_class_id"], name: "index_deluxe_packages_on_training_class_id"

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "event_start_date"
    t.date     "event_end_date"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
  end

  create_table "gun_ranges", force: true do |t|
    t.string "name"
  end

  create_table "homepage_videos", force: true do |t|
    t.string "url"
  end

  create_table "instructors", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text   "bio"
    t.string "image"
  end

  create_table "lanes", force: true do |t|
    t.integer "number"
    t.integer "gun_range_id"
  end

  add_index "lanes", ["gun_range_id"], name: "index_lanes_on_gun_range_id"

  create_table "master_reservations", force: true do |t|
    t.integer  "user_id"
    t.string   "gun_type"
    t.integer  "number_of_guests"
    t.datetime "created_at"
    t.boolean  "paid",             default: false
    t.string   "payment_method"
    t.boolean  "checked_in",       default: false
    t.datetime "checked_in_at"
  end

  add_index "master_reservations", ["user_id"], name: "index_master_reservations_on_user_id"

  create_table "memberships", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.float   "annual_price",                default: 0.0
    t.float   "monthly_price",               default: 0.0
    t.string  "hex_color"
    t.integer "range_hours"
    t.integer "training_discount"
    t.integer "range_ammo_discount"
    t.integer "accessory_discount"
    t.integer "private_instructor_discount"
    t.integer "annual_guest_passes"
    t.boolean "lounge_access",               default: true
    t.string  "stripe_plan_id"
  end

  add_index "memberships", ["stripe_plan_id"], name: "index_memberships_on_stripe_plan_id"

  create_table "menu_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_item_options", force: true do |t|
    t.string  "name"
    t.integer "menu_item_id"
  end

  add_index "menu_item_options", ["menu_item_id"], name: "index_menu_item_options_on_menu_item_id"

  create_table "menu_items", force: true do |t|
    t.integer  "menu_category_id"
    t.float    "price"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_items", ["menu_category_id"], name: "index_menu_items_on_menu_category_id"

  create_table "order_delivery_addresses", force: true do |t|
    t.integer "order_id"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
  end

  add_index "order_delivery_addresses", ["order_id"], name: "index_order_delivery_addresses_on_order_id"

  create_table "order_item_options", force: true do |t|
    t.integer "menu_item_option_id"
    t.integer "order_item_id"
  end

  add_index "order_item_options", ["menu_item_option_id"], name: "index_order_item_options_on_menu_item_option_id"
  add_index "order_item_options", ["order_item_id"], name: "index_order_item_options_on_order_item_id"

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "menu_item_id"
    t.float    "price",                default: 0.0
    t.text     "special_instructions"
    t.integer  "quantity",             default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["menu_item_id"], name: "index_order_items_on_menu_item_id"
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"
  add_index "order_items", ["user_id"], name: "index_order_items_on_user_id"

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.boolean  "delivery",       default: false
    t.float    "item_total",     default: 0.0
    t.float    "delivery_total", default: 0.0
    t.float    "total_price",    default: 0.0
    t.string   "payment_method"
    t.boolean  "completed",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "paymentable_type"
    t.integer  "paymentable_id"
    t.string   "charge_token"
    t.string   "card_last_4"
    t.string   "card_brand"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "payments", ["paymentable_id"], name: "index_payments_on_paymentable_id"
  add_index "payments", ["user_id"], name: "index_payments_on_user_id"

  create_table "reservations", force: true do |t|
    t.integer  "user_id"
    t.integer  "lane_id"
    t.integer  "gun_range_id"
    t.date     "day"
    t.datetime "reservation_time"
    t.integer  "master_reservation_id"
  end

  add_index "reservations", ["gun_range_id"], name: "index_reservations_on_gun_range_id"
  add_index "reservations", ["lane_id"], name: "index_reservations_on_lane_id"
  add_index "reservations", ["master_reservation_id"], name: "index_reservations_on_master_reservation_id"
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "subscriptions", force: true do |t|
    t.integer  "membership_id"
    t.integer  "payment_id"
    t.integer  "user_id"
    t.date     "expires_on"
    t.string   "description"
    t.float    "amount_paid"
    t.datetime "created_at"
  end

  add_index "subscriptions", ["membership_id"], name: "index_subscriptions_on_membership_id"
  add_index "subscriptions", ["payment_id"], name: "index_subscriptions_on_payment_id"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "training_classes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.string   "ammo_requirement"
    t.text     "credential_requirement", limit: 255
    t.text     "equipment_requirement",  limit: 255
    t.boolean  "foid_required",                      default: true
    t.string   "moniker"
    t.boolean  "active",                             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_sessions", force: true do |t|
    t.date     "session_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "training_class_id"
    t.integer  "instructor_id"
    t.integer  "quantity_available", default: 24
    t.boolean  "deluxe_package",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_sessions", ["instructor_id"], name: "index_training_sessions_on_instructor_id"
  add_index "training_sessions", ["training_class_id"], name: "index_training_sessions_on_training_class_id"

  create_table "user_training_sessions", force: true do |t|
    t.integer  "training_session_id"
    t.integer  "user_id"
    t.boolean  "deluxe_package",      default: false
    t.string   "payment_method"
    t.boolean  "paid",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_training_sessions", ["training_session_id"], name: "index_user_training_sessions_on_training_session_id"
  add_index "user_training_sessions", ["user_id"], name: "index_user_training_sessions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.date     "date_of_birth"
    t.boolean  "admin",                  default: false
    t.integer  "foid_id"
    t.date     "membership_expires_on"
    t.integer  "membership_id"
    t.string   "membership_type"
    t.decimal  "hours_available",        default: 0.0
    t.integer  "guests_left",            default: 0
    t.string   "stripe_customer_token"
    t.string   "email",                                  null: false
    t.string   "encrypted_password",                     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "foid_or_license"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["foid_id"], name: "index_users_on_foid_id"
  add_index "users", ["membership_id"], name: "index_users_on_membership_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "waivers", force: true do |t|
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "last_name"
    t.string  "email"
    t.date    "date_of_birth"
    t.string  "foid_or_license"
    t.string  "address1"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.boolean "mental_illness",  default: false
    t.boolean "substance_abuse", default: false
    t.boolean "criminal_record", default: false
    t.boolean "us_citizen",      default: false
    t.integer "user_id"
  end

  add_index "waivers", ["user_id"], name: "index_waivers_on_user_id"

end
