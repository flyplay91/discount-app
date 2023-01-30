class ChnageLeadTimeColumn < ActiveRecord::Migration[5.2]
  def self.up
  	rename_column :vendors, :lead_time, :standard_production_lead_time_range
  	change_column :vendors, :standard_production_lead_time_range, :string
  end

  def self.down
  	change_column :vendors, :standard_production_lead_time_range, :integer
  	rename_column :vendors, :standard_production_lead_time_range, :lead_time
  end
end
