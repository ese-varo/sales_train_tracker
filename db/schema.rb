# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_26_234922) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "contact_name"
    t.string "contact_phone"
    t.boolean "active"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "tax_id"
    t.string "contact_email"
    t.string "contact_phone"
    t.text "address"
    t.boolean "active", default: true
    t.string "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "printer_configs", force: :cascade do |t|
    t.string "name"
    t.string "device_id"
    t.string "printer_type"
    t.integer "location_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_printer_configs_on_location_id"
  end

  create_table "report_templates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "template_data"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_report_templates_on_organization_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.integer "payment_method"
    t.integer "number_of_passengers"
    t.text "notes"
    t.datetime "timestamp"
    t.integer "user_id", null: false
    t.integer "location_id", null: false
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_sales_on_location_id"
    t.index ["organization_id"], name: "index_sales_on_organization_id"
    t.index ["timestamp"], name: "index_sales_on_timestamp"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "ticket_number"
    t.datetime "valid_until"
    t.integer "sale_id", null: false
    t.integer "template_id"
    t.boolean "printed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_tickets_on_sale_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.boolean "active"
    t.integer "organization_id", null: false
    t.integer "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["location_id"], name: "index_users_on_location_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "locations", "organizations"
  add_foreign_key "printer_configs", "locations"
  add_foreign_key "report_templates", "organizations"
  add_foreign_key "sales", "locations"
  add_foreign_key "sales", "organizations"
  add_foreign_key "sales", "users"
  add_foreign_key "tickets", "sales"
  add_foreign_key "users", "locations"
  add_foreign_key "users", "organizations"
end
