class AddSettingFieldsToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :from_email, :string, default: 'orders@keeperscollective.com'
    add_column :shops, :staff_accounts, :text
    add_column :shops, :purchase_order_statuses, :text
    add_column :shops, :purchase_order_stages, :text
    add_column :shops, :purchase_order_next_actions, :text
  end
end
