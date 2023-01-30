class Add3rdPartyTypeFieldToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :third_party_shipping_fee_type, :integer, default: 0
  end
end
