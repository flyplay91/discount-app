class AddDefaultAgents < ActiveRecord::Migration[5.2]
  def change
  	add_column :shops, :default_agents, :text
  end
end
