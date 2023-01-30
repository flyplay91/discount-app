class CreatePurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_orders do |t|
    	t.string :draft_order_id
    	t.string :status
    	t.belongs_to :shop, index: true

      t.timestamps
    end
    add_index :purchase_orders, :draft_order_id
  end
end
