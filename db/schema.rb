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

ActiveRecord::Schema.define(version: 2019_05_14_184619) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "english", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "activity_type", null: false
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.integer "score", default: 0
    t.text "description"
    t.text "pitch_audience"
    t.text "abstract_outline"
    t.string "files"
    t.boolean "english_approve"
    t.string "slug"
    t.bigint "match_id"
    t.index ["match_id"], name: "index_activities_on_match_id"
    t.index ["slug"], name: "index_activities_on_slug", unique: true
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "content_approvations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "approve", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_type"
    t.bigint "content_id"
    t.index ["content_type", "content_id"], name: "index_content_approvations_on_content_type_and_content_id"
    t.index ["user_id"], name: "index_content_approvations_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "comment"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.string "file"
    t.index ["commentable_type", "commentable_id"], name: "index_feedbacks_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approve", default: false
    t.bigint "activity_id", null: false
    t.index ["activity_id"], name: "index_locations_on_activity_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "match_type"
    t.integer "version"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "polls", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "match_id"
    t.index ["match_id"], name: "index_polls_on_match_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "repositories"
    t.text "features"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "match_id"
    t.bigint "team_id"
    t.integer "score", default: 0
    t.string "slug"
    t.integer "status", default: 0
    t.index ["match_id"], name: "index_projects_on_match_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["team_id"], name: "index_projects_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "match_id"
    t.index ["match_id"], name: "index_teams_on_match_id"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "poll_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value", null: false
    t.string "content_type"
    t.bigint "content_id"
    t.index ["content_type", "content_id"], name: "index_votes_on_content_type_and_content_id"
    t.index ["poll_id"], name: "index_votes_on_poll_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "matches"
  add_foreign_key "activities", "users"
  add_foreign_key "locations", "activities"
  add_foreign_key "polls", "matches"
  add_foreign_key "projects", "matches"
  add_foreign_key "projects", "teams"
  add_foreign_key "teams", "matches"
end
