class AddDatesToProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :p_created_at, :datetime
  	add_column :products, :p_updated_at, :datetime
  end
end
