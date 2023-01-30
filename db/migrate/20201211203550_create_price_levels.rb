class CreatePriceLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :price_levels do |t|
    	t.belongs_to :rule, index: true
    	t.integer :break_number
    	t.float :dicount_amount
    	t.integer :discount_type

      t.timestamps
    end
  end
end
