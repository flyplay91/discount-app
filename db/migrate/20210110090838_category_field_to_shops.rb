class CategoryFieldToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :categories, :text
  end
end
