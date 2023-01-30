class ChangeWholeSaleCost < ActiveRecord::Migration[5.2]
  def up
  	change_column :price_levels, :item_wholesale_cost, :float
  end

  def down
  	change_column :price_levels, :item_wholesale_cost, :integer
  end
end
