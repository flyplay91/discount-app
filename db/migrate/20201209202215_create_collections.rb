class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
    	t.string :shopify_id
    	t.string :handle
    	t.string :title
    	t.string :published_scope
    	t.text :body_html
      t.datetime :published_at
    	t.belongs_to :shop, index: true

      t.timestamps
    end

    add_index :collections, :title
    add_index :collections, :shopify_id
  end
end
