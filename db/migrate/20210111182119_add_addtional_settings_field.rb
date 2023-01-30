class AddAddtionalSettingsField < ActiveRecord::Migration[5.2]
  def change
  	add_column :shops, :from_name, :string
  end
end
