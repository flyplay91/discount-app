class AddProductionDetailsFieldsToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :size, :string
    add_column :variants, :color, :string
    add_column :variants, :supplier_product_name, :string
    add_column :variants, :one_time_setup_fee, :decimal, precision: 7, scale: 2
    add_column :variants, :recurring_reorder_fee, :decimal, precision: 7, scale: 2
    add_column :variants, :quote_number, :string
    add_column :variants, :supplier_proof_link, :string
    add_column :variants, :proof_photo_link, :string
    add_column :variants, :decoration_location, :string
    add_column :variants, :decoration_type, :integer, default: 0
    add_column :variants, :logo_name, :string
    add_column :variants, :logo_color, :string
    add_column :variants, :logo_size, :string
    add_column :variants, :inventory_on_hand, :integer
    add_column :variants, :enforced_multiple_quantity, :integer
    add_column :variants, :base_lead_time, :string
    add_column :variants, :start_production, :string
    add_column :variants, :lead_time_in_days, :string
    add_column :variants, :additional_lead_time, :string
    add_column :variants, :ship_to, :integer, default: 0
    add_column :variants, :supplier_decoration, :string
    add_column :variants, :blank_docorator, :string
    add_column :variants, :dst_file, :string
    add_column :variants, :su_comp, :string
    add_column :variants, :different_cost_based_on_quantity, :boolean, default: false
    add_column :variants, :proof_required, :boolean, default: false
  end
end
