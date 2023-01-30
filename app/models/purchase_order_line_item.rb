class PurchaseOrderLineItem < ApplicationRecord
	belongs_to :purchase_order_item
	belongs_to :variant, optional: true

	validates :variant_id, uniqueness: { scope: :purchase_order_item_id }
end
