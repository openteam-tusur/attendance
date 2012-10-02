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

ActiveRecord::Schema.define(:version => 20121002025759) do

  create_table "contexts", :force => true do |t|
    t.string   "title"
    t.string   "ancestry"
    t.string   "weight"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contexts", ["ancestry"], :name => "index_contexts_on_ancestry"
  add_index "contexts", ["weight"], :name => "index_contexts_on_weight"

  create_table "disciplines", :force => true do |t|
    t.text     "title"
    t.string   "abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "faculties", :force => true do |t|
    t.text     "title"
    t.string   "abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "number"
    t.integer  "course"
    t.integer  "faculty_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["faculty_id"], :name => "index_groups_on_faculty_id"

  create_table "lessons", :force => true do |t|
    t.string   "classroom"
    t.date     "date_on"
    t.string   "kind"
    t.string   "order_number"
    t.integer  "timetable_id"
    t.text     "note"
    t.integer  "discipline_id"
    t.integer  "group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "state"
  end

  add_index "lessons", ["discipline_id"], :name => "index_lessons_on_discipline_id"
  add_index "lessons", ["group_id"], :name => "index_lessons_on_group_id"

  create_table "people", :force => true do |t|
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.string   "type"
    t.integer  "contingent_id"
    t.integer  "group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "active"
    t.string   "secure_id"
  end

  add_index "people", ["group_id"], :name => "index_people_on_group_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "role"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], :name => "by_user_and_role_and_context"

  create_table "presences", :force => true do |t|
    t.string   "kind"
    t.integer  "lesson_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "date_on"
  end

  add_index "presences", ["lesson_id"], :name => "index_presences_on_lesson_id"
  add_index "presences", ["student_id"], :name => "index_presences_on_student_id"

  create_table "realizes", :force => true do |t|
    t.integer  "lecturer_id"
    t.integer  "lesson_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "realizes", ["lecturer_id"], :name => "index_realizes_on_lecturer_id"
  add_index "realizes", ["lesson_id"], :name => "index_realizes_on_lesson_id"

  create_table "subcontexts", :force => true do |t|
    t.string   "title"
    t.integer  "context_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.text     "name"
    t.text     "email"
    t.text     "nickname"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "description"
    t.text     "image"
    t.text     "phone"
    t.text     "urls"
    t.text     "raw_info"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
