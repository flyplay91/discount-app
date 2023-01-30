class ChangeDiscountAmountFieldName < ActiveRecord::Migration[5.2]
  def change
    rename_column :price_levels, :dicount_amount, :discount_amount
    change_column_default :price_levels, :discount_type, 0
  end
end
