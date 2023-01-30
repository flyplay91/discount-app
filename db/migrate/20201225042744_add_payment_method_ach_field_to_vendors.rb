class AddPaymentMethodAchFieldToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :payment_methods_ach, :boolean
  end
end
