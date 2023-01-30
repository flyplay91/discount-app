class AddSupplierTypeToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :supplier_type, :integer, default: 0
    add_column :variants, :vendor_types, :text
  end
end
