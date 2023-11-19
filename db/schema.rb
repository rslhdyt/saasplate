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

ActiveRecord::Schema[7.1].define(version: 2023_11_16_160632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true
  end

  create_table "auth_providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "uid"], name: "index_auth_providers_on_name_and_uid", unique: true
    t.index ["user_id"], name: "index_auth_providers_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name", default: "", null: false
    t.string "email"
    t.string "phone"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_companies_on_email", unique: true
    t.index ["owner_id"], name: "index_companies_on_owner_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.uuid "external_id", default: -> { "gen_random_uuid()" }, null: false
    t.string "invoiceable_type", null: false
    t.bigint "invoiceable_id", null: false
    t.bigint "user_id", null: false
    t.integer "total_amount", null: false
    t.date "issue_date", null: false
    t.date "due_date", null: false
    t.integer "status", default: 0, null: false
    t.string "payment_gateway"
    t.string "payment_gateway_ref"
    t.string "invoice_url"
    t.string "invoice_number"
    t.integer "paid_amount", default: 0
    t.date "paid_date"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_invoices_on_invoiceable"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "subscription_packages", force: :cascade do |t|
    t.bigint "subscription_plan_id"
    t.integer "price", null: false
    t.integer "billing_cycle", null: false
    t.integer "billing_duration", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_plan_id"], name: "index_subscription_packages_on_subscription_plan_id"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "image"
    t.string "description", null: false
    t.string "features", default: [], array: true
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "subscription_package_id", null: false
    t.bigint "company_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "price", null: false
    t.integer "billing_cycle", null: false
    t.integer "billing_duration", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_subscriptions_on_company_id"
    t.index ["subscription_package_id"], name: "index_subscriptions_on_subscription_package_id"
  end

  create_table "user_companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_companies_on_company_id"
    t.index ["invitation_token"], name: "index_user_companies_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_user_companies_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_user_companies_on_invited_by"
    t.index ["user_id"], name: "index_user_companies_on_user_id"
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
    t.string "name", default: "", null: false
    t.integer "active_company_id"
    t.boolean "invited", default: false, null: false
    t.string "otp_secret"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_company_id"], name: "index_users_on_active_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "auth_providers", "users"
  add_foreign_key "companies", "users", column: "owner_id"
  add_foreign_key "invoices", "users"
  add_foreign_key "subscription_packages", "subscription_plans"
  add_foreign_key "subscriptions", "companies"
  add_foreign_key "subscriptions", "subscription_packages"
  add_foreign_key "user_companies", "companies"
  add_foreign_key "user_companies", "users"
end
