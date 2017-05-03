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

ActiveRecord::Schema.define(version: 20170412150947) do

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

  create_table "contacts", force: :cascade do |t|
    t.string   "email_pc"
    t.string   "email_phone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "job_domains", force: :cascade do |t|
    t.string   "domain"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "profile_individual_id"
    t.index ["profile_individual_id"], name: "index_job_domains_on_profile_individual_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address"
    t.decimal  "latitude",   precision: 10, scale: 6
    t.decimal  "longitude",  precision: 10, scale: 6
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "profile_families", force: :cascade do |t|
    t.integer  "job_style"
    t.integer  "number_of_children"
    t.integer  "is_photo_ok"
    t.integer  "is_report_ok"
    t.integer  "is_male_ok"
    t.date     "child_birthday"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_profile_families_on_user_id"
  end

  create_table "profile_individuals", force: :cascade do |t|
    t.datetime "birthday"
    t.string   "role"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "profile_family_id"
    t.index ["profile_family_id"], name: "index_profile_individuals_on_profile_family_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.string   "kana",                                   null: false
    t.integer  "gender",                                 null: false
    t.boolean  "is_family",               default: true, null: false
    t.string   "spread_sheets_timestamp"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
