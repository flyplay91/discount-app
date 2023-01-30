class CreateRuleItems < ActiveRecord::Migration[5.2]
  def change
    create_table :rule_items do |t|
      t.string :shopify_id
      t.string :shopify_type
      t.bigint :rule_id
      t.timestamps
    end
  end
end
