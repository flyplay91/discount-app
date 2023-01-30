class AddVendorType < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :vendor_type, :string
  end
end
