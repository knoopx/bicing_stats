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

ActiveRecord::Schema.define(:version => 20111227130758) do
  create_table "hourly_samples", :force => true do |t|
    t.integer "station_id"
    t.integer "used", :default => 0
    t.integer "unused", :default => 0
    t.integer "sum_used", :default => 0
    t.integer "sum_unused", :default => 0
    t.integer "max_used"
    t.integer "min_used"
    t.integer "min_unused"
    t.integer "max_unused"
    t.integer "sample_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hourly_samples", ["created_at"], :name => "index_hourly_samples_on_created_at"
  add_index "hourly_samples", ["station_id"], :name => "index_hourly_samples_on_station_id"

  create_table "stations", :force => true do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.integer "used", :default => 0
    t.integer "unused", :default => 0
    t.integer "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "used_past_hour", :default => 0
    t.integer "unused_past_hour", :default => 0
  end
end
