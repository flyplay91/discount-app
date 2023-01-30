class AddPaymentPrimary < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :payment_primary, :string
  end
end
