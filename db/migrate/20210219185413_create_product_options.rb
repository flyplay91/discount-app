class CreateProductOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_options do |t|
    	t.references :product, index: true
    	t.references :shop, index: true
    	t.string :shopify_id
    	t.string :shopify_product_id
    	t.integer :position
    	t.string :option_name
    	t.string :option_values

      t.timestamps
    end
  end
end
