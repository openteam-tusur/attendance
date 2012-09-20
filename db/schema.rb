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

ActiveRecord::Schema.define(:version => 20120920045656) do

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
    t.datetime "date_on"
    t.string   "kind"
    t.string   "order_number"
    t.integer  "timetable_id"
    t.integer  "discipline_id"
    t.integer  "group_id"
    t.integer  "lecturer_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "lessons", ["discipline_id"], :name => "index_lessons_on_discipline_id"
  add_index "lessons", ["group_id"], :name => "index_lessons_on_group_id"
  add_index "lessons", ["lecturer_id"], :name => "index_lessons_on_lecturer_id"

  create_table "people", :force => true do |t|
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.string   "type"
    t.integer  "contingent_id"
    t.integer  "group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "people", ["group_id"], :name => "index_people_on_group_id"

  create_table "presences", :force => true do |t|
    t.string   "kind"
    t.integer  "lesson_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "presences", ["lesson_id"], :name => "index_presences_on_lesson_id"
  add_index "presences", ["student_id"], :name => "index_presences_on_student_id"

end
