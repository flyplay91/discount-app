class AddExtraFieldsToPriceLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :price_levels, :variant_id, :integer
    add_column :price_levels, :item_qty, :integer
    add_column :price_levels, :item_wholesale_cost, :integer
    add_column :price_levels, :vendor_cost_type, :integer, default: 0
    add_column :price_levels, :vendor_costs, :text
    add_column :price_levels, :item_markup_type, :integer, default: 0
    add_column :price_levels, :item_markup_cost, :integer
  end
end
