class AddSeveralDataToSettings < ActiveRecord::Migration[5.2]
  def change
  	add_column :shops, :customer_info_description, :string
  	add_column :shops, :shipping_details_description, :string
  	add_column :shops, :single_address_description, :string
  	add_column :shops, :dropship_address_description, :string
  	add_column :shops, :dropship_noaddress_description, :string
  	add_column :shops, :address_attachment_type_description, :string
  	add_column :shops, :delivery_needed_by_date_description, :string
  	add_column :shops, :dropship_fee_charge, :float
  end
end
