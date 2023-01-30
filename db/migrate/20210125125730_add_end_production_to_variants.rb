class AddEndProductionToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :end_production, :string
    add_column :variants, :proof_number, :string
    add_column :variants, :supplier_decorated, :string
  end
end
