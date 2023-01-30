class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
    	t.string :name
    	t.boolean :status, default: false
    	t.boolean :display_table, default: true
    	t.integer :rule_type, default: 0
    	t.integer :select_cat, default: 0
    	t.integer :filter_cat, default: 0
    	t.boolean :apply_each, default: true
    	t.datetime :start_time
    	t.datetime :end_time
    	t.text :shopify_ids
    	t.belongs_to :shop, index: true

      t.timestamps
    end
  end
end
