class AddAttachFile < ActiveRecord::Migration[5.2]
  def change
  	def up
  		remove_attachment :carts, :list
	    add_attachment :carts, :asset
	  end

	  def down
	    remove_attachment :carts, :asset
	    add_attachment :carts, :list
	  end
  end
end
