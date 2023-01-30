class AddCollectionsForFilter < ActiveRecord::Migration[5.2]
  def change
  	add_column :shops, :filter_collections, :text
  end
end
