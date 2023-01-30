class AddDropShipUnitType < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :dropship_unit_type, :string
  end
end
