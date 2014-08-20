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

ActiveRecord::Schema.define(version: 20140820090528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "declarations", force: true do |t|
    t.integer  "realize_id"
    t.integer  "declarator_id"
    t.string   "declarator_type"
    t.text     "reason"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "declarations", ["declarator_id", "declarator_type"], name: "index_declarations_on_declarator_id_and_declarator_type", using: :btree
  add_index "declarations", ["realize_id"], name: "index_declarations_on_realize_id", using: :btree

  create_table "disciplines", force: true do |t|
    t.string   "abbr"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", force: true do |t|
    t.string   "title"
    t.string   "abbr"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "number"
    t.integer  "course"
    t.integer  "subdepartment_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["subdepartment_id"], name: "index_groups_on_subdepartment_id", using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "group_id"
    t.integer  "discipline_id"
    t.string   "classroom"
    t.date     "date_on"
    t.string   "kind"
    t.string   "order_number"
    t.string   "timetable_id"
    t.date     "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["discipline_id"], name: "index_lessons_on_discipline_id", using: :btree
  add_index "lessons", ["group_id"], name: "index_lessons_on_group_id", using: :btree

  create_table "memberships", force: true do |t|
    t.string   "participate_type"
    t.integer  "participate_id"
    t.string   "person_type"
    t.integer  "person_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["participate_id", "participate_type"], name: "index_memberships_on_participate_id_and_participate_type", using: :btree
  add_index "memberships", ["person_id", "person_type"], name: "index_memberships_on_person_id_and_person_type", using: :btree

  create_table "misses", force: true do |t|
    t.integer  "missing_id"
    t.string   "missing_type"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "misses", ["missing_id", "missing_type"], name: "index_misses_on_missing_id_and_missing_type", using: :btree

  create_table "people", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "surname"
    t.string   "patronymic"
    t.integer  "contingent_id"
    t.integer  "directory_id"
    t.string   "secure_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "role"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], name: "by_user_and_role_and_context", unique: true, using: :btree

  create_table "presences", force: true do |t|
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presences", ["lesson_id"], name: "index_presences_on_lesson_id", using: :btree
  add_index "presences", ["student_id"], name: "index_presences_on_student_id", using: :btree

  create_table "realizes", force: true do |t|
    t.integer  "lecturer_id"
    t.integer  "lesson_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
  end

  add_index "realizes", ["lecturer_id"], name: "index_realizes_on_lecturer_id", using: :btree
  add_index "realizes", ["lesson_id"], name: "index_realizes_on_lesson_id", using: :btree

  create_table "subdepartments", force: true do |t|
    t.string   "title"
    t.string   "abbr"
    t.integer  "faculty_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subdepartments", ["faculty_id"], name: "index_subdepartments_on_faculty_id", using: :btree

  create_table "syncs", force: true do |t|
    t.string   "state"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "uid"
    t.text     "name"
    t.text     "email"
    t.text     "raw_info"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
