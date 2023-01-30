class CreateConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :conditions do |t|
    	t.belongs_to :rule, index: true
    	t.integer :condition_type, default: 0
    	t.string :condition_str

      t.timestamps
    end
  end
end
