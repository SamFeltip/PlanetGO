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

ActiveRecord::Schema[7.0].define(version: 2023_05_03_213247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "availabilities", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "bug_reports", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "category"
    t.boolean "resolved", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bug_reports_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_interests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.integer "interest", default: 0, null: false
    t.index ["category_id"], name: "index_category_interests_on_category_id"
    t.index ["user_id"], name: "index_category_interests_on_user_id"
  end

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

  create_table "event_reacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_reacts_on_event_id"
    t.index ["user_id"], name: "index_event_reacts_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "time_of_event"
    t.text "description"
    t.boolean "approved"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "address_line1"
    t.string "address_line2"
    t.string "town"
    t.string "postcode"
    t.float "latitude"
    t.float "longitude"
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["latitude"], name: "index_events_on_latitude"
    t.index ["longitude"], name: "index_events_on_longitude"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "followability_relationships", force: :cascade do |t|
    t.string "followerable_type", null: false
    t.bigint "followerable_id", null: false
    t.string "followable_type", null: false
    t.bigint "followable_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followable_type", "followable_id"], name: "index_followability_relationships_on_followable"
    t.index ["followerable_type", "followerable_id"], name: "index_followability_relationships_on_followerable"
  end

  create_table "metrics", force: :cascade do |t|
    t.datetime "time_enter"
    t.datetime "time_exit"
    t.string "route"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_logged_in"
    t.integer "number_interactions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country_code"
  end

  create_table "outings", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invitation_token"
    t.integer "outing_type"
    t.bigint "creator_id", null: false
    t.index ["creator_id"], name: "index_outings_on_creator_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "outing_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outing_id"], name: "index_participants_on_outing_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "proposed_events", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "outing_id", null: false
    t.datetime "proposed_datetime"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_proposed_events_on_event_id"
    t.index ["outing_id"], name: "index_proposed_events_on_outing_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "full_name", null: false
    t.boolean "suspended", default: false
    t.string "postcode"
    t.float "latitude"
    t.float "longitude"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["latitude"], name: "index_users_on_latitude"
    t.index ["longitude"], name: "index_users_on_longitude"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availabilities", "users"
  add_foreign_key "bug_reports", "users"
  add_foreign_key "category_interests", "categories"
  add_foreign_key "category_interests", "users"
  add_foreign_key "event_reacts", "events"
  add_foreign_key "event_reacts", "users"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "users"
  add_foreign_key "outings", "users", column: "creator_id"
  add_foreign_key "participants", "outings"
  add_foreign_key "participants", "users"
  add_foreign_key "proposed_events", "events"
  add_foreign_key "proposed_events", "outings"
end
