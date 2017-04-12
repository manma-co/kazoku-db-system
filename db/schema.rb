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

ActiveRecord::Schema.define(version: 20170412133549) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "profile_families", force: :cascade do |t|
    t.text     "how_find_out"
    t.string   "family_structure"
    t.integer  "childcare_ratio"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email_pc",    default: "",   null: false
    t.string   "email_phone", default: "",   null: false
    t.string   "tel"
    t.string   "name",                       null: false
    t.string   "kana",                       null: false
    t.integer  "sex",                        null: false
    t.string   "address"
    t.boolean  "is_family",   default: true, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["email_pc"], name: "index_users_on_email_pc", unique: true
  end

end
