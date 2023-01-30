class AddVendorFieldsToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :vendor_id, :integer
    add_column :variants, :vender_sub_brand, :string
    add_column :variants, :supplier_sku, :string
    add_column :variants, :artwork_url, :string
    add_column :variants, :inventory_available, :integer
    add_column :variants, :min_item_order_qty, :integer
    add_column :variants, :max_item_order_qty, :integer
    add_column :variants, :item_qty_per_case, :integer
  end
end
