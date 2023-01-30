class CreatePurchaseOrderLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_order_line_items do |t|
    	t.belongs_to :purchase_order_item, index: true
    	t.belongs_to :variant, index: true
    	t.integer :qty
    	t.float :unit_cost

      t.timestamps
    end
  end
end
