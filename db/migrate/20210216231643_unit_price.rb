class UnitPrice < ActiveRecord::Migration[5.2]
  def change
  	add_column :price_levels, :unit_price, :decimal, precision: 7, scale: 2, default: 0
  end
end
