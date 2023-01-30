class StringToText < ActiveRecord::Migration[5.2]
  def up
  	change_column :product_options, :option_values, :text
  end

  def down
  	change_column :product_options, :option_values, :string
  end
end
