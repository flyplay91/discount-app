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

ActiveRecord::Schema.define(version: 2021_03_03_205348) do

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "token"
    t.text "json_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "full_json"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["shop_id"], name: "index_carts_on_shop_id"
  end

  create_table "collection_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "collection_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "product_id"], name: "index_collection_products_on_collection_id_and_product_id", unique: true
    t.index ["collection_id"], name: "index_collection_products_on_collection_id"
    t.index ["product_id"], name: "index_collection_products_on_product_id"
  end

  create_table "collections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "shopify_id"
    t.string "handle"
    t.string "title"
    t.string "published_scope"
    t.text "body_html"
    t.datetime "published_at"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_collections_on_shop_id"
    t.index ["shopify_id"], name: "index_collections_on_shopify_id"
    t.index ["title"], name: "index_collections_on_title"
  end

  create_table "conditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "rule_id"
    t.integer "condition_type", default: 0
    t.string "condition_str"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_id"], name: "index_conditions_on_rule_id"
  end

  create_table "lead_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "vendor_id"
    t.integer "min_qty"
    t.integer "max_qty"
    t.integer "min_days"
    t.integer "max_days"
    t.integer "period_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "rule_id"
    t.integer "break_number"
    t.float "discount_amount"
    t.integer "discount_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "variant_id"
    t.integer "item_qty"
    t.decimal "item_wholesale_cost", precision: 7, scale: 2
    t.integer "vendor_cost_type", default: 0
    t.text "vendor_costs"
    t.integer "item_markup_type", default: 0
    t.integer "item_markup_cost"
    t.decimal "item_sale_price", precision: 7, scale: 2
    t.integer "sale_price_quantity"
    t.decimal "supplier_cost", precision: 7, scale: 2
    t.decimal "decorator_cost", precision: 7, scale: 2
    t.decimal "unit_price", precision: 7, scale: 2, default: "0.0"
    t.bigint "product_id"
    t.index ["product_id"], name: "index_price_levels_on_product_id"
    t.index ["rule_id"], name: "index_price_levels_on_rule_id"
  end

  create_table "product_options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "shop_id"
    t.string "shopify_id"
    t.string "shopify_product_id"
    t.integer "position"
    t.string "option_name"
    t.text "option_values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_options_on_product_id"
    t.index ["shop_id"], name: "index_product_options_on_shop_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "shopify_id"
    t.string "handle"
    t.string "featured_image"
    t.string "title"
    t.string "tags"
    t.string "vendor"
    t.string "product_type"
    t.string "published_scope"
    t.text "body_html"
    t.float "min_price"
    t.float "max_price"
    t.datetime "published_at"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "p_created_at"
    t.datetime "p_updated_at"
    t.index ["shop_id"], name: "index_products_on_shop_id"
    t.index ["shopify_id"], name: "index_products_on_shopify_id"
    t.index ["title"], name: "index_products_on_title"
  end

  create_table "purchase_order_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "purchase_order_id"
    t.bigint "vendor_id"
    t.integer "status", default: 0
    t.datetime "invoice_sent_at"
    t.datetime "required_ship_date"
    t.string "shipping_method"
    t.text "shipping_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id"
    t.index ["shop_id"], name: "index_purchase_order_items_on_shop_id"
    t.index ["vendor_id"], name: "index_purchase_order_items_on_vendor_id"
  end

  create_table "purchase_order_line_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "purchase_order_item_id"
    t.bigint "variant_id"
    t.integer "qty"
    t.float "unit_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "setup_qty"
    t.float "setup_unit_price"
    t.integer "run_qty"
    t.float "run_unit_price"
    t.float "freight_cost"
    t.index ["purchase_order_item_id"], name: "index_purchase_order_line_items_on_purchase_order_item_id"
    t.index ["variant_id"], name: "index_purchase_order_line_items_on_variant_id"
  end

  create_table "purchase_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "draft_order_id"
    t.string "status"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "assigned_account"
    t.string "draft_order_status"
    t.index ["draft_order_id"], name: "index_purchase_orders_on_draft_order_id"
    t.index ["shop_id"], name: "index_purchase_orders_on_shop_id"
  end

  create_table "rule_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "shopify_id"
    t.string "shopify_type"
    t.bigint "rule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_1"
    t.string "name_2"
  end

  create_table "rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "status", default: false
    t.boolean "display_table", default: true
    t.integer "rule_type", default: 0
    t.integer "select_cat", default: 0
    t.integer "filter_cat", default: 0
    t.boolean "apply_each", default: true
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "shopify_ids"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_rules_on_shop_id"
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "processing_fee", precision: 10, scale: 2
    t.string "from_email", default: "orders@keeperscollective.com"
    t.text "staff_accounts"
    t.text "purchase_order_statuses"
    t.text "purchase_order_stages"
    t.text "purchase_order_next_actions"
    t.text "categories"
    t.string "from_name"
    t.string "customer_info_description"
    t.string "shipping_details_description"
    t.string "single_address_description"
    t.string "dropship_address_description"
    t.string "dropship_noaddress_description"
    t.text "address_attachment_type_description"
    t.text "delivery_needed_by_date_description"
    t.float "dropship_fee_charge"
    t.text "terms_and_conditions"
    t.float "tax_rate", default: 7.5
    t.string "bcc_email"
    t.string "bcc_name"
    t.text "default_agents"
    t.text "draft_order_statuses"
    t.text "disclaimers"
    t.text "filter_collections"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "variants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "shopify_id"
    t.string "shopify_product_id"
    t.string "title"
    t.float "price"
    t.float "compare_at_price"
    t.string "sku"
    t.string "inventory_policy"
    t.string "fulfillment_service"
    t.string "inventory_management"
    t.string "option_1"
    t.string "option_2"
    t.string "option_3"
    t.string "barcode"
    t.bigint "inventory_item_id"
    t.bigint "shop_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vendor_id"
    t.string "vender_sub_brand"
    t.string "supplier_sku"
    t.string "artwork_url"
    t.integer "inventory_available"
    t.integer "min_item_order_qty"
    t.integer "max_item_order_qty"
    t.integer "item_qty_per_case"
    t.text "vendor_ids"
    t.text "vender_sub_brands"
    t.integer "standard_lead_in_days"
    t.integer "supplier_type", default: 0
    t.text "vendor_types"
    t.string "size"
    t.string "color"
    t.string "supplier_product_name"
    t.decimal "one_time_setup_fee", precision: 7, scale: 2
    t.decimal "recurring_reorder_fee", precision: 7, scale: 2
    t.string "quote_number"
    t.string "supplier_proof_link"
    t.string "proof_photo_link"
    t.string "decoration_location"
    t.integer "decoration_type", default: 0
    t.string "logo_name"
    t.string "logo_color"
    t.string "logo_size"
    t.integer "inventory_on_hand"
    t.integer "enforced_multiple_quantity"
    t.string "base_lead_time"
    t.string "start_production"
    t.string "lead_time_in_days"
    t.string "additional_lead_time"
    t.integer "ship_to", default: 0
    t.string "supplier_decoration"
    t.string "blank_docorator"
    t.string "dst_file"
    t.string "su_comp"
    t.boolean "different_cost_based_on_quantity", default: false
    t.boolean "proof_required", default: false
    t.string "end_production"
    t.string "proof_number"
    t.string "supplier_decorated"
    t.string "su_proof_link"
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["shop_id"], name: "index_variants_on_shop_id"
    t.index ["shopify_id"], name: "index_variants_on_shopify_id"
    t.index ["title"], name: "index_variants_on_title"
  end

  create_table "vendors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "company_name"
    t.string "product_contact_name"
    t.string "product_phone_number"
    t.string "product_contact_email"
    t.string "company_address_line_1"
    t.string "company_address_line_2"
    t.string "company_address_city"
    t.string "company_address_state"
    t.string "company_address_zipcode"
    t.integer "net_payment_terms", default: 0
    t.string "net_terms_custom"
    t.boolean "payment_methods_check"
    t.boolean "payment_methods_cc"
    t.decimal "payment_methods_cc_fees", precision: 5, scale: 2
    t.boolean "payment_methods_custom"
    t.string "payment_methods_custom_field"
    t.text "po_emails"
    t.integer "order_submission_type", default: 0
    t.string "order_submission_portal_link"
    t.string "order_submission_portal_login"
    t.string "order_submission_portal_password"
    t.string "order_submission_comment"
    t.text "sub_brands"
    t.text "shipping_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.boolean "payment_methods_ach"
    t.string "billing_contact_name"
    t.text "private_notes"
    t.string "category"
    t.text "payment_notes"
    t.string "website"
    t.string "billing_contact_phone_number"
    t.string "billing_contact_email"
    t.text "categories"
    t.integer "payment_methods_cc_type", default: 0
    t.boolean "third_shipping"
    t.string "payment_primary"
    t.string "custom_net_term_description"
    t.string "standard_production_lead_time_range"
    t.boolean "international_supplier"
    t.float "third_shipping_fee"
    t.string "company_type"
    t.string "company_type_custom"
    t.string "pricing_status"
    t.string "pricing_status_other"
    t.float "dropship_fee_per_item_per_location"
    t.string "assigned_agent_name"
    t.string "assigned_agent_email"
    t.string "company_contact_email"
    t.string "custom_service_phone_number"
    t.integer "third_party_shipping_fee_type", default: 0
    t.string "vendor_type"
    t.string "dropship_unit_type"
  end

end
