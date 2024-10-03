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

ActiveRecord::Schema[7.2].define(version: 2024_09_30_182207) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.index ["group_id"], name: "index_categories_on_group_id"
  end

  create_table "customer_branches", force: :cascade do |t|
    t.string "branch_location"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.datetime "deleted_at"
    t.index ["customer_id"], name: "index_customer_branches_on_customer_id"
    t.index ["deleted_at"], name: "index_customer_branches_on_deleted_at"
    t.index ["group_id"], name: "index_customer_branches_on_group_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_customers_on_deleted_at"
    t.index ["group_id"], name: "index_customers_on_group_id"
  end

  create_table "delivery_orders", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "customer_branch_id", null: false
    t.bigint "driver_id"
    t.bigint "vehicle_id", null: false
    t.bigint "order_group_id", null: false
    t.string "status"
    t.date "dispatched_date"
    t.date "delivery_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_branch_id"], name: "index_delivery_orders_on_customer_branch_id"
    t.index ["customer_id"], name: "index_delivery_orders_on_customer_id"
    t.index ["driver_id"], name: "index_delivery_orders_on_driver_id"
    t.index ["group_id"], name: "index_delivery_orders_on_group_id"
    t.index ["order_group_id"], name: "index_delivery_orders_on_order_group_id"
    t.index ["vehicle_id"], name: "index_delivery_orders_on_vehicle_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_no"
    t.string "address"
    t.string "status", default: "0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_drivers_on_deleted_at"
    t.index ["group_id"], name: "index_drivers_on_group_id"
  end

  create_table "goods", force: :cascade do |t|
    t.string "name"
    t.string "sold_as"
    t.string "unit"
    t.string "availability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_goods_on_category_id"
    t.index ["group_id"], name: "index_goods_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "goods_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit"
    t.bigint "delivery_order_id", null: false
    t.index ["delivery_order_id"], name: "index_line_items_on_delivery_order_id"
    t.index ["goods_id"], name: "index_line_items_on_goods_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "order_groups", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.date "planned_at", null: false
    t.bigint "customer_id", null: false
    t.bigint "customer_branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurring", default: false
    t.string "recurrence_frequency"
    t.date "next_due_date"
    t.date "recurrence_end_date"
    t.integer "parent_order_group_id"
    t.boolean "skip_update", default: false
    t.index ["customer_branch_id"], name: "index_order_groups_on_customer_branch_id"
    t.index ["customer_id"], name: "index_order_groups_on_customer_id"
    t.index ["group_id"], name: "index_order_groups_on_group_id"
    t.index ["parent_order_group_id"], name: "index_order_groups_on_parent_order_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.bigint "group_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_plate"
    t.string "brand"
    t.string "model"
    t.string "vehicle_type"
    t.string "status"
    t.integer "capacity"
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "images"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_vehicles_on_deleted_at"
    t.index ["group_id"], name: "index_vehicles_on_group_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "groups"
  add_foreign_key "customer_branches", "customers"
  add_foreign_key "customer_branches", "groups"
  add_foreign_key "customers", "groups"
  add_foreign_key "delivery_orders", "customer_branches"
  add_foreign_key "delivery_orders", "customers"
  add_foreign_key "delivery_orders", "drivers"
  add_foreign_key "delivery_orders", "groups"
  add_foreign_key "delivery_orders", "order_groups"
  add_foreign_key "delivery_orders", "vehicles"
  add_foreign_key "drivers", "groups"
  add_foreign_key "goods", "categories"
  add_foreign_key "goods", "groups"
  add_foreign_key "line_items", "delivery_orders"
  add_foreign_key "line_items", "goods", column: "goods_id"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "order_groups", "customer_branches"
  add_foreign_key "order_groups", "customers"
  add_foreign_key "order_groups", "groups"
  add_foreign_key "users", "groups"
  add_foreign_key "vehicles", "groups"
end
