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

ActiveRecord::Schema.define(version: 2021_05_04_010945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "patients", force: :cascade do |t|
    t.integer "gender"
    t.float "age"
    t.boolean "hypertension"
    t.boolean "heart_disease"
    t.boolean "ever_married"
    t.integer "work_type"
    t.integer "residence_type"
    t.float "avg_glucose_level"
    t.float "bmi"
    t.integer "smoking_status"
    t.boolean "stroke"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
