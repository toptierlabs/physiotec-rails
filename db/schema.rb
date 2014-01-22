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

ActiveRecord::Schema.define(:version => 20140121170320) do

  create_table "actions", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "actions", ["name"], :name => "index_actions_on_name", :unique => true

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

  create_table "assignments", :force => true do |t|
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "categories", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "context_id",   :null => false
    t.string   "context_type", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "categories", ["context_type", "context_id"], :name => "index_categories_on_context_type_and_context_id"
  add_index "categories", ["owner_id"], :name => "index_categories_on_owner_id"

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"

  create_table "clinics", :force => true do |t|
    t.string   "name"
    t.integer  "license_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "api_license_id"
  end

  add_index "clinics", ["api_license_id"], :name => "index_clinics_on_api_license_id"
  add_index "clinics", ["license_id"], :name => "index_clinics_on_license_id"

  create_table "exercise_illustrations", :force => true do |t|
    t.integer  "exercise_id"
    t.string   "illustration"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "token"
  end

  add_index "exercise_illustrations", ["exercise_id"], :name => "index_exercise_illustrations_on_exercise_id"

  create_table "exercise_images", :force => true do |t|
    t.integer  "exercise_id"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "token"
  end

  add_index "exercise_images", ["exercise_id"], :name => "index_exercise_images_on_exercise_id"

  create_table "exercise_translations", :force => true do |t|
    t.integer  "exercise_id"
    t.string   "locale",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title"
    t.string   "short_title"
    t.string   "description"
  end

  add_index "exercise_translations", ["exercise_id"], :name => "index_exercise_translations_on_exercise_id"
  add_index "exercise_translations", ["locale"], :name => "index_exercise_translations_on_locale"

  create_table "exercise_videos", :force => true do |t|
    t.integer  "exercise_id"
    t.string   "video"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "exercise_videos", ["exercise_id"], :name => "index_exercise_videos_on_exercise_id"
  add_index "exercise_videos", ["token", "video", "exercise_id"], :name => "index_exercise_videos_on_token_and_video_and_exercise_id", :unique => true
  add_index "exercise_videos", ["token"], :name => "index_exercise_videos_on_token"

  create_table "exercises", :force => true do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.integer  "owner_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "api_license_id"
    t.string   "code"
    t.string   "token"
  end

  add_index "exercises", ["api_license_id"], :name => "index_exercises_on_api_license_id"
  add_index "exercises", ["owner_id"], :name => "index_exercises_on_owner_id"

  create_table "languages", :force => true do |t|
    t.integer  "api_license_id"
    t.string   "locale"
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "languages", ["api_license_id"], :name => "index_languages_on_api_license_id"

  create_table "licenses", :force => true do |t|
    t.integer  "maximum_clinics"
    t.integer  "maximum_users"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "api_license_id"
    t.string   "company_name"
  end

  create_table "permissible_scopes", :force => true do |t|
    t.integer  "permissible_id"
    t.string   "permissible_type"
    t.integer  "scope_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "permissible_scopes", ["permissible_id"], :name => "index_permissible_scopes_on_permissible_id"
  add_index "permissible_scopes", ["permissible_type"], :name => "index_permissible_scopes_on_permissible_type"

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
    t.string   "model_name"
  end

  create_table "profile_assignments", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "destination_profile_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "profile_assignments", ["destination_profile_id"], :name => "index_profile_assignments_on_destination_profile_id"
  add_index "profile_assignments", ["profile_id"], :name => "index_profile_assignments_on_profile_id"

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
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "api_license_id"
    t.boolean  "protected",      :default => false
  end

  add_index "profiles", ["api_license_id"], :name => "index_profiles_on_api_license_id"

  create_table "scope_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "scope_permission_group_scopes", :force => true do |t|
    t.integer  "scope_permission_id"
    t.integer  "scope_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "scope_permission_group_scopes", ["scope_id"], :name => "index_scope_permission_group_scopes_on_scope_id"
  add_index "scope_permission_group_scopes", ["scope_permission_id"], :name => "index_scope_permission_group_scopes_on_scope_permission_id"

  create_table "scope_permissions", :force => true do |t|
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "action_id"
  end

  add_index "scope_permissions", ["action_id"], :name => "index_scope_permissions_on_action_id"
  add_index "scope_permissions", ["permission_id"], :name => "index_scope_permissions_on_permission_id"

  create_table "scopes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "scope_group_id"
  end

  create_table "section_data", :force => true do |t|
    t.integer  "api_license_id", :null => false
    t.integer  "context_id",     :null => false
    t.string   "context_type",   :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "section_data", ["api_license_id"], :name => "index_section_data_on_api_license_id"
  add_index "section_data", ["context_type", "context_id"], :name => "index_section_data_on_context_type_and_context_id"

  create_table "section_datum_translations", :force => true do |t|
    t.integer  "section_datum_id"
    t.string   "locale",           :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "name"
  end

  add_index "section_datum_translations", ["locale"], :name => "index_section_datum_translations_on_locale"
  add_index "section_datum_translations", ["section_datum_id"], :name => "index_section_datum_translations_on_section_datum_id"

  create_table "sections", :force => true do |t|
    t.integer  "category_id",      :null => false
    t.integer  "section_datum_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "sections", ["category_id"], :name => "index_sections_on_category_id"
  add_index "sections", ["section_datum_id", "category_id"], :name => "index_sections_on_section_datum_id_and_category_id", :unique => true
  add_index "sections", ["section_datum_id"], :name => "index_sections_on_section_datum_id"

  create_table "subsection_data", :force => true do |t|
    t.integer  "section_datum_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "subsection_data", ["section_datum_id"], :name => "index_subsection_data_on_section_datum_id"

  create_table "subsection_datum_translations", :force => true do |t|
    t.integer  "subsection_datum_id"
    t.string   "locale",              :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "name"
  end

  add_index "subsection_datum_translations", ["locale"], :name => "index_subsection_datum_translations_on_locale"
  add_index "subsection_datum_translations", ["subsection_datum_id"], :name => "index_subsection_datum_translations_on_subsection_datum_id"

  create_table "subsection_exercises", :force => true do |t|
    t.integer  "subsection_id"
    t.integer  "exercise_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "subsection_exercises", ["exercise_id", "subsection_id"], :name => "index_subsection_exercises_on_exercise_id_and_subsection_id", :unique => true
  add_index "subsection_exercises", ["exercise_id"], :name => "index_subsection_exercises_on_exercise_id"
  add_index "subsection_exercises", ["subsection_id"], :name => "index_subsection_exercises_on_subsection_id"

  create_table "subsections", :force => true do |t|
    t.integer  "section_id",          :null => false
    t.integer  "subsection_datum_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "subsections", ["section_id", "subsection_datum_id"], :name => "index_subsections_on_section_id_and_subsection_datum_id", :unique => true
  add_index "subsections", ["section_id"], :name => "index_subsections_on_section_id"
  add_index "subsections", ["subsection_datum_id"], :name => "index_subsections_on_subsection_datum_id"

  create_table "user_clinics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "clinic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_clinics", ["clinic_id"], :name => "index_user_clinics_on_clinic_id"
  add_index "user_clinics", ["user_id"], :name => "index_user_clinics_on_user_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_profiles", ["profile_id"], :name => "index_user_profiles_on_profile_id"
  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

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
    t.integer  "context_id"
    t.string   "context_type"
  end

  add_index "users", ["confirmation_token"], :name => "index_api_license_admins_on_confirmation_token", :unique => true
  add_index "users", ["context_id"], :name => "index_users_on_context_id"
  add_index "users", ["context_type"], :name => "index_users_on_context_type"
  add_index "users", ["email", "api_license_id"], :name => "index_users_on_email_and_api_license_id", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_api_license_admins_on_reset_password_token", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
