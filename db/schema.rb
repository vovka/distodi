# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170730165658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_kinds", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "abbreviation"
  end

  create_table "action_kinds_categories", force: :cascade do |t|
    t.integer "action_kind_id"
    t.integer "category_id"
  end

  add_index "action_kinds_categories", ["action_kind_id"], name: "index_action_kinds_categories_on_action_kind_id", using: :btree
  add_index "action_kinds_categories", ["category_id"], name: "index_action_kinds_categories_on_category_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "attribute_kinds", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attribute_kinds_categories", force: :cascade do |t|
    t.integer "attribute_kind_id"
    t.integer "category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_service_kinds", force: :cascade do |t|
    t.integer "category_id"
    t.integer "service_kind_id"
  end

  add_index "categories_service_kinds", ["category_id"], name: "index_categories_service_kinds_on_category_id", using: :btree
  add_index "categories_service_kinds", ["service_kind_id"], name: "index_categories_service_kinds_on_service_kind_id", using: :btree

  create_table "characteristics", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "attribute_kind_id"
    t.string   "value"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "website"
    t.string   "notice"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "picture"
    t.boolean  "active",                 default: true
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "demo"
  end

  add_index "companies", ["email"], name: "index_companies_on_email", unique: true, using: :btree
  add_index "companies", ["invitation_token"], name: "index_companies_on_invitation_token", unique: true, using: :btree
  add_index "companies", ["invitations_count"], name: "index_companies_on_invitations_count", using: :btree
  add_index "companies", ["invited_by_id"], name: "index_companies_on_invited_by_id", using: :btree
  add_index "companies", ["reset_password_token"], name: "index_companies_on_reset_password_token", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.integer  "category_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.string   "picture"
    t.string   "token"
    t.string   "id_code"
    t.integer  "transferring_to_id"
    t.boolean  "demo"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_action_kinds", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "action_kind_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "service_action_kinds", ["action_kind_id"], name: "index_service_action_kinds_on_action_kind_id", using: :btree
  add_index "service_action_kinds", ["service_id"], name: "index_service_action_kinds_on_service_id", using: :btree

  create_table "service_fields", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "service_kind_id"
    t.string   "text"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "service_fields", ["service_id"], name: "index_service_fields_on_service_id", using: :btree
  add_index "service_fields", ["service_kind_id"], name: "index_service_fields_on_service_kind_id", using: :btree

  create_table "service_kinds", force: :cascade do |t|
    t.string   "title"
    t.boolean  "with_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "item_id"
    t.date     "next_control"
    t.string   "picture"
    t.float    "price"
    t.integer  "company_id"
    t.boolean  "confirmed"
    t.string   "status",                     default: "pending"
    t.integer  "approver_id"
    t.string   "approver_type"
    t.string   "reason",        limit: 1023
    t.string   "id_code"
    t.boolean  "demo"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.string   "notice"
    t.string   "picture"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "categories_service_kinds", "categories"
  add_foreign_key "categories_service_kinds", "service_kinds"
  add_foreign_key "service_action_kinds", "action_kinds"
  add_foreign_key "service_action_kinds", "services"
  add_foreign_key "service_fields", "service_kinds"
  add_foreign_key "service_fields", "services"
end
