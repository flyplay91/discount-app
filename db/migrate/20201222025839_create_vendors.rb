class CreateVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :vendors do |t|
      t.string :company_name
      t.string :customer_service_contact_name
      t.string :cutomer_service_phone_number
      t.string :company_contact_email
      t.string :company_address_line_1
      t.string :company_address_line_2
      t.string :company_address_city
      t.string :company_address_state
      t.string :company_address_zipcode
      t.integer :net_payment_terms, default: 0
      t.string :net_terms_custom
      t.boolean :payment_methods_check
      t.boolean :payment_methods_cc
      t.integer :payment_methods_cc_fees
      t.boolean :payment_methods_custom
      t.string :payment_methods_custom_field
      t.text :po_emails
      t.integer :order_submission_type, default: 0
      t.string :order_submission_portal_link
      t.string :order_submission_portal_login
      t.string :order_submission_portal_password
      t.string :order_submission_comment
      t.text :sub_brands
      t.text :shipping_notes
      t.timestamps
    end
  end
end
