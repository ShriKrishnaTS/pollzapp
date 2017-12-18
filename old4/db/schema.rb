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

ActiveRecord::Schema.define(version: 20170209095046) do

  create_table "admin_view_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "view"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "comments_enabled"
    t.index ["poll_id"], name: "index_comments_on_poll_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.string   "os"
    t.string   "push_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id", using: :btree
  end

  create_table "group_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "comments_enabled",            default: false
    t.boolean  "new_polls_enabled",           default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "user_type",         limit: 1
    t.boolean  "active",                      default: true
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "mute_till"
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.integer  "privacy",                  limit: 1
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "admins_can_add_users",               default: true
    t.boolean  "members_can_create_polls",           default: true
    t.string   "share_id"
  end

  create_table "joins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "status",     limit: 1
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "text"
    t.text     "parts",       limit: 65535
    t.string   "icon"
    t.integer  "user_id"
    t.boolean  "pushed",                    default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "read",                      default: false, null: false
    t.integer  "poll_id"
    t.integer  "group_id"
    t.string   "name"
    t.string   "username"
    t.string   "image"
    t.string   "user_image"
    t.string   "poll_title"
    t.string   "group_title"
    t.string   "creator_id"
    t.string   "link"
    t.string   "description"
    t.string   "code"
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "poll_read_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.boolean  "read",        default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "last_viewed", default: '2017-02-07 08:03:54'
    t.index ["poll_id"], name: "index_poll_read_statuses_on_poll_id", using: :btree
    t.index ["user_id"], name: "index_poll_read_statuses_on_user_id", using: :btree
  end

  create_table "polls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "question"
    t.integer  "duration",                                             unsigned: true
    t.datetime "ends_on"
    t.boolean  "comments_enabled",        default: true
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "image_1"
    t.string   "image_2"
    t.string   "option_1"
    t.string   "option_2"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "composite"
    t.string   "video"
    t.boolean  "end_msg_sent",            default: false, null: false
    t.boolean  "half_time_msg_sent",      default: false, null: false
    t.boolean  "before_an_hour_msg_sent", default: false, null: false
    t.boolean  "not_voted",               default: false, null: false
    t.index ["group_id"], name: "index_polls_on_group_id", using: :btree
    t.index ["user_id"], name: "index_polls_on_user_id", using: :btree
  end

  create_table "polls_tags", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "poll_id", null: false
    t.integer "tag_id",  null: false
    t.index ["poll_id", "tag_id"], name: "index_polls_tags_on_poll_id_and_tag_id", using: :btree
  end

  create_table "rails_push_notifications_apns_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "apns_dev_cert",  limit: 65535
    t.text     "apns_prod_cert", limit: 65535
    t.boolean  "sandbox_mode"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "rails_push_notifications_gcm_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "gcm_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_mpns_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "cert",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "rails_push_notifications_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "destinations", limit: 65535
    t.integer  "app_id"
    t.string   "app_type"
    t.text     "data",         limit: 65535
    t.text     "results",      limit: 65535
    t.integer  "success"
    t.integer  "failed"
    t.boolean  "sent",                       default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "link"
    t.integer  "creator_id"
    t.integer  "group_id"
    t.integer  "user_id"
    t.index ["app_id", "app_type", "sent"], name: "app_and_sent_index_on_rails_push_notifications", using: :btree
  end

  create_table "read_polls_status", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "polls_id"
    t.integer "user_id"
    t.boolean "read",     default: false, null: false
  end

  create_table "shares", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.integer  "contact_id",                              unsigned: true
    t.boolean  "blocked",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name"
    t.string   "phone"
    t.index ["contact_id"], name: "index_user_contacts_on_contact_id", using: :btree
    t.index ["user_id"], name: "index_user_contacts_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                  limit: 64
    t.string   "username",              limit: 64
    t.string   "phone",                 limit: 20
    t.string   "otp_secret_key"
    t.string   "image"
    t.string   "auth_token",            limit: 64
    t.boolean  "notifications_enabled",            default: true, null: false
    t.integer  "language",              limit: 1,  default: 0,    null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.string   "choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_votes_on_poll_id", using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
  end

  add_foreign_key "comments", "polls", on_delete: :cascade
  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "devices", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "poll_read_statuses", "polls"
  add_foreign_key "poll_read_statuses", "users"
  add_foreign_key "polls", "groups", on_delete: :cascade
  add_foreign_key "polls", "users", on_delete: :cascade
  add_foreign_key "votes", "polls", on_delete: :cascade
  add_foreign_key "votes", "users", on_delete: :cascade
end
