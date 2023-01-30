class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
    	t.string :shopify_id
    	t.string :handle
    	t.string :featured_image
      t.string :title
      t.string :tags
      t.string :vendor
      t.string :product_type
      t.string :published_scope
      t.text :body_html
      t.float :min_price
      t.float :max_price
      t.datetime :published_at
      t.belongs_to :shop, index: true

      t.timestamps
    end
    add_index :products, :title
    add_index :products, :shopify_id
  end
end
