class AddNameFieldsToRuleItems < ActiveRecord::Migration[5.2]
  def change
    add_column :rule_items, :name_1, :string
    add_column :rule_items, :name_2, :string
  end
end
