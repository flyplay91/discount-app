class AddAssignedAgentToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :assigned_agent_name, :string
    add_column :vendors, :assigned_agent_email, :string
  end
end
