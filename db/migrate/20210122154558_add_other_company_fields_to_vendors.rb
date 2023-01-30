class AddOtherCompanyFieldsToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :company_contact_email, :string
    add_column :vendors, :custom_service_phone_number, :string
    change_column :vendors, :payment_methods_cc_fees, :decimal, precision: 5, scale: 2
  end
end
