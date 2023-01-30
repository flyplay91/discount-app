class AddAttach < ActiveRecord::Migration[5.2]
  def change
  	def up
	    add_attachment :carts, :list
	  end

	  def down
	    remove_attachment :carts, :list
	  end
  end
end
