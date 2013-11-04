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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131104205620) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "api_licenses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "public_api_key"
    t.string   "secret_api_key"
  end

  add_index "api_licenses", ["public_api_key"], :name => "index_api_licenses_on_public_api_key"

  create_table "licenses", :force => true do |t|
    t.integer  "maximum_clinics"
    t.integer  "maximum_users"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "permission_scope_groups", :force => true do |t|
    t.integer  "permission_id"
    t.integer  "scope_group_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "permission_scope_groups", ["permission_id"], :name => "index_permission_scope_groups_on_permission_id"
  add_index "permission_scope_groups", ["scope_group_id"], :name => "index_permission_scope_groups_on_scope_group_id"

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profile_scope_permissions", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "scope_permission_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "profile_scope_permissions", ["profile_id"], :name => "index_profile_scope_permissions_on_profile_id"
  add_index "profile_scope_permissions", ["scope_permission_id"], :name => "index_profile_scope_permissions_on_scope_permission_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scope_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "scope_permissions", :force => true do |t|
    t.integer  "scope_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "scope_permissions", ["permission_id"], :name => "index_scope_permissions_on_permission_id"
  add_index "scope_permissions", ["scope_id"], :name => "index_scope_permissions_on_scope_id"

  create_table "scopes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "scope_group_id"
  end

  create_table "user_scope_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "scope_permission_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "user_scope_permissions", ["scope_permission_id"], :name => "index_user_scope_permissions_on_scope_permission_id"
  add_index "user_scope_permissions", ["user_id"], :name => "index_user_scope_permissions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name",                               :null => false
    t.string   "last_name",                                :null => false
    t.integer  "api_license_id",                           :null => false
    t.string   "email",                    :default => "", :null => false
    t.string   "encrypted_password",       :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "session_token"
    t.date     "session_token_created_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_api_license_admins_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_api_license_admins_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_api_license_admins_on_reset_password_token", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
