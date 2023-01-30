class AddDropShipFeePerItemPerLocation < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :dropship_fee_per_item_per_location, :float
  end
end
