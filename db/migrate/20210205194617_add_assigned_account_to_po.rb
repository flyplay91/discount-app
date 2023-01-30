class AddAssignedAccountToPo < ActiveRecord::Migration[5.2]
  def change
  	add_column :purchase_orders, :assigned_account, :string
  end
end
