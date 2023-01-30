class AddEnabledFieldToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :enabled, :boolean, default: true
  end
end
