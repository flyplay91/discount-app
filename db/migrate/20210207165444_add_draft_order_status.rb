class AddDraftOrderStatus < ActiveRecord::Migration[5.2]
  def change
  	add_column :purchase_orders, :draft_order_status, :string
  end
end
