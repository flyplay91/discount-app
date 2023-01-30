class AddAttachment < ActiveRecord::Migration[5.2]
  def up
		# remove_attachment :carts, :asset
    add_attachment :carts, :attachment
  end

  def down
    remove_attachment :carts, :attachment
    # add_attachment :carts, :asset
  end
end
