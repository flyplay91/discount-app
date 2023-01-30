class AddLeadTimeToVendor < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :lead_time, :integer
  end
end
