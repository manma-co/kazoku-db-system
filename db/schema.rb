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

ActiveRecord::Schema.define(version: 20200212145135) do

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
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "email_queues", force: :cascade do |t|
    t.string   "sender_address", null: false
    t.string   "to_address",     null: false
    t.string   "cc_address"
    t.string   "bcc_address"
    t.string   "subject"
    t.text     "body_text"
    t.integer  "request_log_id"
    t.integer  "retry_count"
    t.boolean  "sent_status"
    t.string   "email_type"
    t.datetime "time_delivered"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["request_log_id"], name: "index_email_queues_on_request_log_id"
  end

  create_table "event_dates", force: :cascade do |t|
    t.date     "hold_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "user_id"
    t.integer  "request_log_id"
    t.string   "meeting_place"
    t.string   "emergency_contact"
    t.boolean  "is_first_time",     default: false
    t.text     "information"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "is_amazon_card"
    t.index ["request_log_id"], name: "index_event_dates_on_request_log_id"
    t.index ["user_id"], name: "index_event_dates_on_user_id"
  end

  create_table "job_domains", force: :cascade do |t|
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "news_letters", force: :cascade do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "distribution"
    t.string   "send_to"
    t.boolean  "is_sent",      default: false
    t.boolean  "is_save",      default: false
    t.boolean  "is_monthly",   default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string   "name"
    t.string   "kana"
    t.string   "belong"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_participants_on_email", unique: true
  end

  create_table "profile_families", force: :cascade do |t|
    t.integer  "job_style"
    t.integer  "number_of_children"
    t.integer  "is_photo_ok"
    t.integer  "is_report_ok"
    t.integer  "is_male_ok"
    t.string   "has_time_shortening_experience"
    t.string   "has_childcare_leave_experience"
    t.string   "has_job_change_experience"
    t.string   "married_mother_age"
    t.string   "married_father_age"
    t.string   "first_childbirth_mother_age"
    t.date     "child_birthday"
    t.string   "opinion_or_question"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_profile_families_on_user_id"
  end

  create_table "profile_individuals", force: :cascade do |t|
    t.datetime "birthday"
    t.string   "hometown"
    t.string   "role"
    t.string   "company"
    t.string   "career"
    t.string   "has_experience_abroad"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "profile_family_id"
    t.integer  "job_domain_id"
    t.string   "job_domain_str"
    t.index ["job_domain_id"], name: "index_profile_individuals_on_job_domain_id"
    t.index ["profile_family_id"], name: "index_profile_individuals_on_profile_family_id"
  end

  create_table "reply_logs", force: :cascade do |t|
    t.boolean  "result"
    t.integer  "request_log_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "answer_status",  default: 0
    t.index ["answer_status"], name: "index_reply_logs_on_answer_status"
    t.index ["request_log_id"], name: "index_reply_logs_on_request_log_id"
    t.index ["user_id"], name: "index_reply_logs_on_user_id"
  end

  create_table "request_days", force: :cascade do |t|
    t.integer  "request_log_id"
    t.date     "day"
    t.string   "time"
    t.boolean  "decided",        default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["request_log_id"], name: "index_request_days_on_request_log_id"
  end

  create_table "request_logs", force: :cascade do |t|
    t.string   "hashed_key"
    t.string   "name"
    t.string   "belongs"
    t.string   "station"
    t.string   "email"
    t.string   "emergency"
    t.text     "motivation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.string   "kana",                                   null: false
    t.integer  "gender",                                 null: false
    t.boolean  "is_family",               default: true, null: false
    t.string   "spread_sheets_timestamp"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "deleted_at"
  end

end
