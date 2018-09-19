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

ActiveRecord::Schema.define(version: 20180117220915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string   "content"
    t.datetime "start_date"
    t.datetime "due_date"
    t.boolean  "is_achieve",       default: false
    t.integer  "user_id"
    t.string   "achievement_type"
    t.integer  "value"
    t.index ["user_id"], name: "index_achievements_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id"
    t.text     "content"
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "configs", force: :cascade do |t|
    t.boolean  "is_invitable",   default: true
    t.boolean  "is_commentable", default: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "group_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["recipient_id", "sender_id"], name: "index_conversations_on_recipient_id_and_sender_id", unique: true, using: :btree
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_conversations_on_sender_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "city"
    t.boolean  "private_status"
    t.float    "distance"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "friends", force: :cascade do |t|
    t.integer "user"
    t.integer "status"
    t.text    "description"
  end

  create_table "friendships", force: :cascade do |t|
    t.string   "friendable_type"
    t.integer  "friendable_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blocker_id"
    t.integer  "status"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.boolean  "private_status"
    t.string   "name"
    t.integer  "user_id"
    t.text     "description"
    t.integer  "config_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["user_id"], name: "index_groups_on_user_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "invitation_type"
    t.integer  "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.index ["receiver_id"], name: "index_invitations_on_receiver_id", using: :btree
    t.index ["user_id"], name: "index_invitations_on_user_id", using: :btree
  end

  create_table "member_requests", force: :cascade do |t|
    t.string   "requests_type"
    t.integer  "requests_id"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "role"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "target"
    t.index ["requests_type", "requests_id"], name: "index_member_requests_on_requests_type_and_requests_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "read"
    t.string   "applicant"
    t.integer  "request_id"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_type_and_target_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "url"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "comment_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.index ["comment_id"], name: "index_pictures_on_comment_id", using: :btree
    t.index ["event_id"], name: "index_pictures_on_event_id", using: :btree
    t.index ["group_id"], name: "index_pictures_on_group_id", using: :btree
    t.index ["post_id"], name: "index_pictures_on_post_id", using: :btree
    t.index ["user_id"], name: "index_pictures_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "owner"
    t.text     "content"
    t.string   "picture"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.boolean  "private",    default: false
    t.integer  "like",       default: 0
    t.integer  "event_id"
    t.integer  "group_id"
    t.index ["event_id"], name: "index_posts_on_event_id", using: :btree
    t.index ["group_id"], name: "index_posts_on_group_id", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "runs", force: :cascade do |t|
    t.string   "coordinates"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.datetime "started_at"
    t.integer  "total_distance"
    t.integer  "total_time"
    t.integer  "max_speed"
    t.float    "calories",       default: 0.0
    t.boolean  "is_spot",        default: false
    t.index ["user_id"], name: "index_runs_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                                       default: "",  null: false
    t.string   "encrypted_password",                                          default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                               default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.text     "address"
    t.boolean  "enable"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token",   limit: 40
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "weight",                                                      default: 60
    t.decimal  "longitude",                         precision: 15, scale: 13
    t.decimal  "latitude",                          precision: 15, scale: 13
    t.boolean  "alone"
    t.float    "average_speed",                                               default: 8.0
    t.integer  "kilometer_done"
    t.integer  "total_calorie"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "achievements", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "events", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "invitations", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "pictures", "comments"
  add_foreign_key "pictures", "events"
  add_foreign_key "pictures", "groups"
  add_foreign_key "pictures", "posts"
  add_foreign_key "pictures", "users"
  add_foreign_key "posts", "events"
  add_foreign_key "posts", "groups"
  add_foreign_key "runs", "users"
end
