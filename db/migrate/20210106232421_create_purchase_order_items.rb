class CreatePurchaseOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_order_items do |t|
    	t.belongs_to :shop, index: true
    	t.belongs_to :purchase_order, index: true
    	t.belongs_to :vendor, index: true
    	t.integer :status, default: 0
    	t.datetime :invoice_sent_at

    	t.datetime :required_ship_date
    	t.string :shipping_method
    	t.text :shipping_address
    	t.text :notes

      t.timestamps
    end
  end
end
