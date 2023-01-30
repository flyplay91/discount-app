class AddFreightCost < ActiveRecord::Migration[5.2]
  def change
  	add_column :purchase_order_line_items, :freight_cost, :float
  end
end
