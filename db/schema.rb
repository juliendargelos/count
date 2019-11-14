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

ActiveRecord::Schema.define(version: 2019_11_14_013338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "missions", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name"
    t.date "beginning_date"
    t.date "ending_date"
    t.bigint "user_id"
    t.bigint "referent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_missions_on_project_id"
    t.index ["referent_id"], name: "index_missions_on_referent_id"
    t.index ["user_id"], name: "index_missions_on_user_id"
    t.index ["uuid"], name: "index_missions_on_uuid"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "country"
    t.string "city"
    t.string "zipcode"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_people_on_company_id"
  end

  create_table "pricings", force: :cascade do |t|
    t.string "name"
    t.integer "man_day_price_in_cents"
    t.bigint "mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_pricings_on_mission_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_projects_on_company_id"
  end

  create_table "referentials", force: :cascade do |t|
    t.integer "man_day_duration_in_seconds"
    t.integer "work_per_day_duration_in_seconds"
    t.bigint "mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_referentials_on_mission_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.integer "difficulty"
    t.integer "minimum_duration_in_seconds"
    t.integer "maximum_duration_in_seconds"
    t.bigint "mission_id"
    t.bigint "pricing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["mission_id"], name: "index_tasks_on_mission_id"
    t.index ["position", "mission_id"], name: "index_tasks_on_position_and_mission_id", unique: true
    t.index ["pricing_id"], name: "index_tasks_on_pricing_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.float "weight"
    t.bigint "mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_taxes_on_mission_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "phone", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "siret"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "missions", "people", column: "referent_id"
  add_foreign_key "missions", "projects"
  add_foreign_key "missions", "users"
  add_foreign_key "people", "companies"
  add_foreign_key "pricings", "missions"
  add_foreign_key "referentials", "missions"
  add_foreign_key "tasks", "missions"
  add_foreign_key "tasks", "pricings"
  add_foreign_key "taxes", "missions"
end
