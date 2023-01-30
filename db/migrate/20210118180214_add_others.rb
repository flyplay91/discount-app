class AddOthers < ActiveRecord::Migration[5.2]
  def change
  	add_column :shops, :terms_and_conditions, :text
  	add_column :shops, :tax_rate, :float, default: 7.5
  	add_column :shops, :bcc_email, :string
  	add_column :shops, :bcc_name, :string
  end
end
