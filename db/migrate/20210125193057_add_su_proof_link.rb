class AddSuProofLink < ActiveRecord::Migration[5.2]
  def change
  	add_column :variants, :su_proof_link, :string
  end
end
