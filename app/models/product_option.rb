class ProductOption < ApplicationRecord
	validates :shopify_id, presence: true
	validates :option_name, presence: true
  belongs_to :shop, optional: true
  belongs_to :product, optional: true
  serialize :option_values, Array 
end
