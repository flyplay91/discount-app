class MakeTableForCollectionAndProductRelations < ActiveRecord::Migration[5.2]
  def change
  	create_table :collection_products do |t|
    	t.belongs_to :collection, index: true
      t.belongs_to :product, index: true
      
      t.timestamps
    end
    add_index :collection_products, [:collection_id, :product_id], unique: true
  end
end
