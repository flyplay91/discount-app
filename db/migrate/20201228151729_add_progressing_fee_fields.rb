class AddProgressingFeeFields < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :processing_fee, :decimal, precision: 10, scale: 2
  end
end
