class CreateLeadTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :lead_times do |t|
      t.bigint :vendor_id
      t.integer :min_qty
      t.integer :max_qty
      t.integer :min_days
      t.integer :max_days
      t.integer :period_type
      t.timestamps
    end
  end
end
