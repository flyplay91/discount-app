class AddProductToPriceLevel < ActiveRecord::Migration[5.2]
  def change
  	add_reference :price_levels, :product, index: true
  end
end
