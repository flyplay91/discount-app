class AddOtherFieldsToPriceLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :price_levels, :item_sale_price, :decimal, precision: 7, scale: 2
    change_column :price_levels, :item_wholesale_cost, :decimal, precision: 7, scale: 2
    add_column :price_levels, :sale_price_quantity, :integer
    add_column :price_levels, :supplier_cost, :decimal, precision: 7, scale: 2
    add_column :price_levels, :decorator_cost, :decimal, precision: 7, scale: 2
  end
end
