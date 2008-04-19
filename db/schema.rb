# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "articles", :force => true do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.string   "link"
    t.string   "author"
    t.text     "content"
    t.datetime "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "title",                                               :null => false
    t.text     "url",             :limit => 255,                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "alternative_url"
    t.string   "type",                           :default => "Feed"
    t.integer  "user_id"
    t.boolean  "active",                         :default => false
    t.string   "frequency",                      :default => "1.day"
  end

end
