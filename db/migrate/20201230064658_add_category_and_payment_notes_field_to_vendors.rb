class AddCategoryAndPaymentNotesFieldToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :category, :string
    add_column :vendors, :payment_notes, :text
  end
end
