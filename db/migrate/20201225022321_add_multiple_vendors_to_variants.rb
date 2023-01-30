class AddMultipleVendorsToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :vendor_ids, :text
    add_column :variants, :vender_sub_brands, :text
  end
end
