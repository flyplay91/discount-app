class AddRunAndSetupData < ActiveRecord::Migration[5.2]
  def change
  	add_column :purchase_order_line_items, :setup_qty, :integer
  	add_column :purchase_order_line_items, :setup_unit_price, :float
  	add_column :purchase_order_line_items, :run_qty, :integer
  	add_column :purchase_order_line_items, :run_unit_price, :float
  end
end
