class AddExtraFieldsToVendonors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :website, :string
    add_column :vendors, :billing_contact_phone_number, :string
    add_column :vendors, :billing_contact_email, :string
    add_column :vendors, :categories, :text
    add_column :vendors, :payment_methods_cc_type, :integer, default: 0
  end
end
