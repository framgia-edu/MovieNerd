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

ActiveRecord::Schema.define(version: 2018_08_28_024521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "movie_tickets", force: :cascade do |t|
    t.bigint "seat_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "screening_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_movie_tickets_on_deleted_at"
    t.index ["order_id"], name: "index_movie_tickets_on_order_id"
    t.index ["screening_id"], name: "index_movie_tickets_on_screening_id"
    t.index ["seat_id", "screening_id"], name: "index_movie_tickets_on_seat_id_and_screening_id", unique: true
    t.index ["seat_id"], name: "index_movie_tickets_on_seat_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "cast"
    t.string "director"
    t.text "description"
    t.integer "duration"
    t.integer "rated"
    t.string "language"
    t.string "genre"
    t.date "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "trailer_url"
    t.string "slug"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_movies_on_deleted_at"
    t.index ["slug"], name: "index_movies_on_slug", unique: true
    t.index ["title"], name: "index_movies_on_title", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "screening_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "paid", default: 1
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
    t.index ["screening_id"], name: "index_orders_on_screening_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "seat_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at"
  end

  create_table "screenings", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "room_id"
    t.datetime "screening_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_screenings_on_deleted_at"
    t.index ["movie_id"], name: "index_screenings_on_movie_id"
    t.index ["room_id"], name: "index_screenings_on_room_id"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "row"
    t.integer "number"
    t.integer "seat_type"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_seats_on_deleted_at"
    t.index ["room_id", "row", "number"], name: "index_seats_on_room_id_and_row_and_number", unique: true
    t.index ["room_id"], name: "index_seats_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "user_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blocked", default: 1
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "slug"
    t.string "provider"
    t.string "uid"
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "movie_tickets", "orders"
  add_foreign_key "movie_tickets", "screenings"
  add_foreign_key "movie_tickets", "seats"
  add_foreign_key "orders", "screenings"
  add_foreign_key "orders", "users"
  add_foreign_key "screenings", "movies"
  add_foreign_key "screenings", "rooms"
  add_foreign_key "seats", "rooms"
end
