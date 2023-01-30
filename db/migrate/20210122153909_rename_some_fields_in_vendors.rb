class RenameSomeFieldsInVendors < ActiveRecord::Migration[5.2]
  def change
    rename_column :vendors, :customer_service_contact_name, :product_contact_name
    rename_column :vendors, :cutomer_service_phone_number, :product_phone_number
    rename_column :vendors, :company_contact_email, :product_contact_email
  end
end
