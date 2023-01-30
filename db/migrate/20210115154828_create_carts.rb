class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
    	t.belongs_to :shop, index: true
    	t.string :token
    	t.text :json_data

      t.timestamps
    end
  end
end