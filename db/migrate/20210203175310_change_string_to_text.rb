class ChangeStringToText < ActiveRecord::Migration[5.2]
  def up
  	change_column :shops, :delivery_needed_by_date_description, :text
  	change_column :shops, :address_attachment_type_description, :text
  	add_column :shops, :disclaimers, :text
  end

  def down
  	change_column :shops, :delivery_needed_by_date_description, :string
  	change_column :shops, :address_attachment_type_description, :string
  	remove_column :shops, :disclaimers
  end
end
