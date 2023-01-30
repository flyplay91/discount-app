class AddDraftOrderStatusesToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :draft_order_statuses, :text
  end
end
