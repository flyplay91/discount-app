class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
    	t.string :shopify_id
    	t.string :shopify_product_id
    	t.string :title
    	t.float :price
    	t.float :compare_at_price
    	t.string :sku
    	t.string :inventory_policy
    	t.string :fulfillment_service
    	t.string :inventory_management
    	t.string :option_1
    	t.string :option_2
    	t.string :option_3
    	t.string :barcode
      t.bigint :inventory_item_id
      t.belongs_to :shop, index: true
      t.belongs_to :product, index: true

      t.timestamps
    end
    add_index :variants, :title
    add_index :variants, :shopify_id
  end
end
