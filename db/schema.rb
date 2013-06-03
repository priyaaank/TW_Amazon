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

ActiveRecord::Schema.define(:version => 20130521024429) do

  create_table "active_admin_comments", :force => true do |t|
    t.string    "resource_id",   :null => false
    t.string    "resource_type", :null => false
    t.integer   "author_id"
    t.string    "author_type"
    t.text      "body"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
    t.string    "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "auction_messages", :force => true do |t|
    t.integer   "silent_auction_id"
    t.text      "message"
    t.string    "creator"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
  end

  create_table "bids", :force => true do |t|
    t.float     "amount"
    t.boolean   "active",            :default => true
    t.integer   "silent_auction_id"
    t.integer   "user_id"
    t.timestamp "created_at",                          :null => false
    t.timestamp "updated_at",                          :null => false
  end

  add_index "bids", ["silent_auction_id"], :name => "index_bids_on_silent_auction_id"
  add_index "bids", ["user_id", "silent_auction_id"], :name => "index_bids_on_user_id_and_silent_auction_id", :unique => true
  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "categories", :force => true do |t|
    t.string    "category"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "email_notifications", :force => true do |t|
    t.integer   "users_id"
    t.boolean   "item_ending"
    t.boolean   "item_won",                    :default => true
    t.boolean   "item_will_sell"
    t.boolean   "item_not_sell"
    t.boolean   "item_not_win"
    t.boolean   "auction_messages_by_creator"
    t.boolean   "auction_messages_by_other"
    t.boolean   "creator_auction_messages"
    t.boolean   "new_items"
    t.integer   "new_items_category"
    t.boolean   "item_outbid",                 :default => true
    t.boolean   "auction_starts"
    t.timestamp "created_at",                                    :null => false
    t.timestamp "updated_at",                                    :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer   "silent_auction_id"
    t.string    "image"
    t.timestamp "created_at",        :null => false
    t.timestamp "updated_at",        :null => false
    t.string    "caption"
  end

  create_table "regions", :force => true do |t|
    t.string    "code"
    t.string    "currency"
    t.string    "timezone"
    t.integer   "maximum"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "silent_auctions", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.boolean   "open",        :default => true
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
    t.float     "min_price"
    t.date      "end_date"
    t.date      "start_date"
    t.string    "creator"
    t.string    "item_type",   :default => "Silent Auction"
    t.integer   "region_id"
    t.integer   "category_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                          :null => false
    t.string   "encrypted_password"
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "admin"
    t.integer  "region_id"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
