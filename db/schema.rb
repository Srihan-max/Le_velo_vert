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

ActiveRecord::Schema[7.0].define(version: 2025_12_01_144407) do
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

  create_table "actualites", force: :cascade do |t|
    t.string "titre", null: false
    t.text "contenu", null: false
    t.date "date_publication", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_publication"], name: "index_actualites_on_date_publication"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "itineraires", force: :cascade do |t|
    t.string "nom", null: false
    t.text "description", null: false
    t.decimal "distance_km", precision: 6, scale: 2, null: false
    t.integer "duree_minutes", null: false
    t.string "niveau", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["niveau"], name: "index_itineraires_on_niveau"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "nom", null: false
    t.string "prenom", null: false
    t.string "email", null: false
    t.string "telephone", null: false
    t.integer "velo_id", null: false
    t.date "date_debut", null: false
    t.date "date_fin", null: false
    t.text "commentaire"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_debut"], name: "index_reservations_on_date_debut"
    t.index ["date_fin"], name: "index_reservations_on_date_fin"
    t.index ["email"], name: "index_reservations_on_email"
    t.index ["velo_id"], name: "index_reservations_on_velo_id"
  end

  create_table "velos", force: :cascade do |t|
    t.string "nom", null: false
    t.string "type_velo", null: false
    t.text "description", null: false
    t.decimal "tarif_heure", precision: 8, scale: 2, null: false
    t.decimal "tarif_jour", precision: 8, scale: 2, null: false
    t.boolean "disponible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disponible"], name: "index_velos_on_disponible"
    t.index ["type_velo"], name: "index_velos_on_type_velo"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "reservations", "velos"
end
