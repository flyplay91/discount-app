class AddBillingContactNameFieldToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :billing_contact_name, :string
    add_column :vendors, :private_notes, :text
  end
end
