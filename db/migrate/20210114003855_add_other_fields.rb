class AddOtherFields < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :international_supplier, :boolean
  	add_column :vendors, :third_shipping_fee, :float
  	add_column :vendors, :company_type, :string
  	add_column :vendors, :company_type_custom, :string
  	add_column :vendors, :pricing_status, :string
  	add_column :vendors, :pricing_status_other, :string
  end
end
