class AddAdditionalsForShipping < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :third_shipping, :boolean
  end
end
