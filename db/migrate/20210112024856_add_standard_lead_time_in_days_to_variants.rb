class AddStandardLeadTimeInDaysToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :standard_lead_in_days, :integer
  end
end
