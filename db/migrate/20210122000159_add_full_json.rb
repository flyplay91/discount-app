class AddFullJson < ActiveRecord::Migration[5.2]
  def change
  	add_column :carts, :full_json, :text
  end
end
