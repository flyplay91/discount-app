class PriceLevel < ApplicationRecord
	belongs_to :rule, optional: true
  belongs_to :variant, optional: true
  belongs_to :product, optional: true
	enum discount_type: { 
    price_discount: 0,
    fixed_price: 1,
    percent_discount: 2
  }

  enum vendor_cost_type: { 
    fixed_vendor: 0,
    percent_vendor: 1
  }

  enum item_markup_type: { 
    fixed_markup: 0,
    percent_markup: 1
  }

  serialize :vendor_costs, Array

  def item_total_markup_cost
    # return if item_wholesale_cost.to_i.zero?
    # return if item_markup_cost.to_i.zero?
    # if fixed_markup?
    #   item_markup_cost + item_wholesale_cost.to_f
    # else
    #   item_wholesale_cost.to_f * (100 + item_markup_cost) / 100
    # end
    return if item_sale_price&.to_f&.zero?
    item_sale_price.to_f
  end

  def get_unit_price
    if item_qty == 0 || item_qty == nil
      0
    else
      (item_sale_price || 0) / item_qty
    end
  end
end
