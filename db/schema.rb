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

ActiveRecord::Schema[7.2].define(version: 2024_11_26_211408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "counties", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "raw_comune"
    t.string "raw_province"
    t.geography "polygon", limit: {:srid=>4326, :type=>"st_polygon", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region_display"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "published_status", default: "IN_REVIEW"
    t.string "status", default: "ACTIVE"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.string "subject"
    t.string "date_info"
    t.index ["code"], name: "index_places_on_code", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.string "name"
    t.string "kind"
    t.string "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_sources_on_place_id"
  end

  add_foreign_key "sources", "places"
end
