class AddCustomTermsDescription < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendors, :custom_net_term_description, :string
  end
end
