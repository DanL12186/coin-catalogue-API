# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_15_211443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.integer "designer_id"
    t.integer "year"
    t.string "mintmark"
    t.string "denomination"
    t.string "category", null: false
    t.string "series"
    t.string "designer"
    t.integer "mintage"
    t.string "generic_img_url"
    t.string "obverse_img_url"
    t.string "reverse_img_url"
    t.json "metal_composition"
    t.float "mass"
    t.float "diameter"
    t.json "price_table"
    t.json "price_history"
    t.json "recent_auction_prices"
    t.json "estimated_survival_rates"
    t.text "comments"
    t.integer "pcgs_num"
    t.integer "ngc_num"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "pcgs_population", default: {}
  end

end
